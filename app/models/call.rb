class Call < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries
  include Filterable

  belongs_to :user
  has_many :participants, dependent: :restrict_with_error
  has_many :contacts, through: :participants
  has_one :recording, dependent: :restrict_with_error
  has_one :transfer_request, dependent: :restrict_with_error
  has_many :transitions,
    class_name: "CallTransition",
    autosave: false,
    dependent: :restrict_with_error

  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }

  scope :active, -> { in_state(:initiated, :in_progress) }
  scope :answered, -> { in_state(:in_progress, :completed) }
  scope :in_progress, -> { in_state(:in_progress) }
  scope :for_user, ->(user) { where(user: user) }
  scope :not_viewed, -> { where(viewed: false) }
  scope :recorded, -> { where(recorded: true) }
  scope :with_contact_phone_number, ->(phone_number) do
    joins(:contacts).merge(Contact.where(phone_number: phone_number))
  end
  scope :missed, ->(is_missed = true) do
    if is_missed
      where(type: "IncomingCall").in_state(:no_answer, :busy, :failed, :canceled)
    else
      joins(Call.most_recent_transition_join)
        .where(type: "OutgoingCall")
        .or(not_in_state(:no_answer, :busy, :failed, :canceled))
    end
  end
  scope :for_contact, ->(contact) do
    joins(:contacts).merge(Contact.where(id: contact.id))
  end

  delegate :in_state?, :transition_to, :current_state, to: :state_machine
  delegate :voicemail_greeting, to: :user

  def self.by_identifier!(identifier)
    find_by(id: identifier) || find_by!(sid: identifier)
  end

  def self.statuses
    CallStateMachine.states
  end

  def self.transition_class
    CallTransition
  end

  def self.initial_state
    :initiated
  end
  private_class_method :initial_state

  def self.mark_viewed
    transaction { not_viewed.update(viewed: true) }.tap do |result|
      if result
        all.distinct.pluck(:user_id).each do |user_id|
          BroadcastCountsJob.perform_later(user_id)
        end
      end
    end
  end

  def state_machine
    @state_machine ||= CallStateMachine.new(
      self,
      transition_class: CallTransition,
      association_name: :transitions
    )
  end

  def active_participants?
    participants.active.exists?
  end

  def active?
    in_state?(:initiated, :in_progress)
  end

  def completed?
    in_state?(:completed)
  end

  def original_participant
    participants.min_by(&:created_at)
  end

  def answered_at
    transitions.find { |transition| transition.to_state == "in_progress" }&.created_at
  end

  def add_participant(phone_number:, sid: nil)
    contact = Contact.from(phone_number: phone_number, user: user)
    participants.create(contact: contact, sid: sid).tap do
      update(internal: participants.all?(&:internal?))
    end
  end

  def toggle_recorded
    return update(recorded: false) if recorded?
    return update(recorded: true) if recordable? && active?

    errors.add(:recorded, "This call is not recordable.")
    false
  end

  def save_recording?
    recordable? && (user.recordable? || recorded?)
  end

  def recordable?
    UnrecordablePhoneNumber.recordable?(participants.map(&:phone_number)) && !internal?
  end

  def owner?(user)
    self.user == user
  end

  def hangup
    EndCall.new(self).call.success?
  end

  def broadcast_in_progress_call
    BroadcastInProgressCallJob.perform_later(id)
  end

  def notify_stats
    StatsCallNotificationJob.perform_later(self)
  end
end

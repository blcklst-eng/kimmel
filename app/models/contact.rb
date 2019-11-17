class Contact < ApplicationRecord
  include Orderable

  belongs_to :user
  has_one :conversation, dependent: :restrict_with_error
  has_many :participants, dependent: :restrict_with_error
  has_many :calls, -> { distinct.latest }, through: :participants
  has_many :incoming_calls, -> { distinct }, through: :participants
  has_many :recordings, -> { latest }, through: :calls
  has_many :voicemails, -> { latest }, through: :incoming_calls

  validates :phone_number, presence: true, uniqueness: {scope: :user}

  searchkick callbacks: :async, text_middle: [:full_name], word_middle: [:phone_number]

  scope :for_user, ->(user) { where(user: user) }
  scope :saved, -> { where(saved: true) }
  scope :order_by_name, ->(direction = :asc) {
    order(Arel.sql("COALESCE(last_name, first_name)"), first_name: direction)
  }

  def search_data
    {
      user_id: user_id,
      full_name: full_name,
      phone_number: phone_number,
      saved: saved,
    }
  end

  def self.from(phone_number:, user:)
    Contact.find_or_create_by(phone_number: phone_number, user: user) do |contact|
      found_user = User.by_number(phone_number)
      if found_user
        contact.update(
          first_name: found_user.first_name,
          last_name: found_user.last_name,
          email: found_user.email
        )
      end
    end
  end

  def remove_from_saved
    update(saved: false)
  end

  def identity
    full_name || phone_number
  end

  def full_name
    return nil if first_name.blank? && last_name.blank?

    "#{first_name} #{last_name}".strip
  end

  def internal?
    PhoneNumber.where(number: phone_number).exists?
  end
end

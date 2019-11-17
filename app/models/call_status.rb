class CallStatus
  TWILIO_MAP = {
    "initiated" => :initiated,
    "queued" => :initiated,
    "ringing" => :initiated,
    "in-progress" => :in_progress,
    "completed" => :completed,
    "busy" => :busy,
    "failed" => :failed,
    "no-answer" => :no_answer,
    "canceled" => :canceled,
  }.freeze

  def initialize(status)
    @status = status
  end

  def self.from_twilio(call_status)
    new(TWILIO_MAP[call_status])
  end

  def apply(call)
    call.transition_to(status)
  end

  def no_answer?
    %i[busy no_answer failed canceled].include?(status)
  end

  def answered?
    status == :in_progress
  end

  private

  attr_accessor :status
end

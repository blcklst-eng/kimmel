class VoicemailGreetingFormatValidator < ActiveModel::Validator
  ACCEPTABLE_MIME_TYPES = [
    "audio/mpeg",
    "audio/wav",
    "audio/wave",
    "audio/x-wav",
    "audio/aiff",
    "audio/x-aifc",
    "audio/x-aiff",
    "audio/x-gsm",
    "audio/gsm",
    "audio/ulaw",
  ].freeze

  def validate(record)
    return unless voicemail_greeting_attached?(record)
    return if valid_voicemail_greeting_format?(record)

    record.errors[:voicemail_greeting] << "Invalid Voicemail Greeting Mimetype"
  end

  private

  def voicemail_greeting_attached?(record)
    record.voicemail_greeting.attached?
  end

  def valid_voicemail_greeting_format?(record)
    record.voicemail_greeting.content_type.in?(ACCEPTABLE_MIME_TYPES)
  end
end

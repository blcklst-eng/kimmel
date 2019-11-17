class VoicemailMailer < ApplicationMailer
  def new_voicemail(voicemail:)
    @voicemail = voicemail
    @call = voicemail.voicemailable

    audio = @voicemail.audio

    attachments["voicemail-#{voicemail.created_at.to_i}.#{audio.filename.extension}"] = {
      mime_type: audio.content_type,
      content: audio.blob.download,
    }

    mail(from: "voicemail@kimmel.com", to: @call.user.email, subject: "New Voicemail from #{@call.from_phone_number}")
  end
end

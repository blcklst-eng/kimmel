class CreateVoicemail
  def initialize(incoming_call:, url:, recording_sid:, downloader: DownloadFile.new)
    @incoming_call = incoming_call
    @url = url
    @recording_sid = recording_sid
    @downloader = downloader
  end

  def call
    voicemail = Voicemail.new(voicemailable: incoming_call, sid: recording_sid)
    attach_audio(voicemail)

    if voicemail.save
      send_email_notification(voicemail) if voicemail.email_voicemails?
      Result.success(voicemail: voicemail)
    else
      Result.failure(voicemail.errors)
    end
  end

  private

  attr_reader :incoming_call, :url, :recording_sid, :downloader

  def attach_audio(voicemail)
    result = downloader.from_url(url)
    return unless result.success?

    voicemail.audio.attach(
      io: result.file,
      filename: "voicemail#{result.extension}"
    )
  end

  def send_email_notification(voicemail)
    SendNewVoicemailEmailJob.perform_later(voicemail.id)
  end
end

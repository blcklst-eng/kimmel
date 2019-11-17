class CreateRecording
  def initialize(call:, url:, downloader: DownloadFile.new, **params)
    @call_to_record = call
    @url = url
    @params = params
    @downloader = downloader
  end

  def call
    return Result.failure("Call is not recordable") unless call_to_record.save_recording?

    recording = call_to_record.build_recording(params)
    attach_audio(recording)

    if recording.save
      Result.success(recording: recording)
    else
      Result.failure(recording.errors)
    end
  end

  private

  attr_reader :call_to_record, :url, :params, :downloader

  def attach_audio(recording)
    result = downloader.from_url(url)
    return unless result.success?

    recording.audio.attach(
      io: result.file,
      filename: "recording#{result.extension}"
    )
  end
end

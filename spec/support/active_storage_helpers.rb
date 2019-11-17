module ActiveStorageHelpers
  module_function

  def create_analyzed_file_blob(*args)
    create_file_blob(*args).tap(&:analyze)
  end

  def create_file_blob(filename: "ruby.jpg", content_type: "image/jpeg", metadata: nil)
    pathname = Pathname.new(Rails.root.to_s + "/spec/fixtures/files/#{filename}")
    ActiveStorage::Blob.create_after_upload!(
      io: pathname.open,
      filename: filename,
      content_type: content_type,
      metadata: metadata
    )
  end

  def create_audio_blob
    create_blob(filename: "audio.wav", content_type: "audio/wav")
  end

  def create_blob(data: "Hello!", filename: "hello.txt", content_type: "text/plain")
    ActiveStorage::Blob.create_after_upload!(
      io: StringIO.new(data),
      filename: filename,
      content_type: content_type
    )
  end
end

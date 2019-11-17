require "open-uri"

class DownloadFile
  MAX_ATTEMPTS = 3
  BACKOFF_MULTIPLIER = 0.5

  def initialize
    @attempts = 0
  end

  def from_url(url)
    resource = URI.parse(url).open
    Result.success(extension: extension(resource), file: resource)
  rescue
    @attempts += 1
    if attempts < MAX_ATTEMPTS
      backoff
      retry
    else
      Result.failure("could not download file")
    end
  end

  private

  attr_accessor :attempts

  def extension(tempfile)
    extension = MIME::Types[tempfile.content_type].first.preferred_extension
    ".#{extension}" if extension
  end

  def backoff
    sleep(attempts.seconds * BACKOFF_MULTIPLIER)
  end
end

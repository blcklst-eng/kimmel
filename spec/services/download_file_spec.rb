require "rails_helper"

RSpec.describe DownloadFile, external_api: true do
  describe ".from_url" do
    it "retrieves a file from a url" do
      url = "https://cdn.kimmel.com/assets/img/common/logo/logo.primary.png"
      result = subject.from_url(url)

      expect(result.success?).to be(true)
      expect(result.file).to be_a(StringIO)
      expect(result.extension).to eq(".png")
    end

    it "retries and then returns an error if it cannot download a file" do
      stub_const("DownloadFile::MAX_ATTEMPTS", 3)
      stub_const("DownloadFile::BACKOFF_MULTIPLIER", 0.001)
      uri_spy = stub_const("URI", spy)
      allow(uri_spy).to receive(:open).and_raise(StandardError)

      result = subject.from_url("https://fake-url/fake-file")

      expect(result.success?).to be(false)
      expect(uri_spy).to have_received(:open).thrice
    end
  end
end

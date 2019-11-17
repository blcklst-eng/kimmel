require "rails_helper"

RSpec.describe CreateRecording do
  describe "#call" do
    it "creates a recording for a call" do
      call = create(:incoming_call)

      params = {
        call: call,
        sid: "1234",
        url: "https://api.twilio.com/cowbell.mp3",
        duration: "100",
        downloader: fake_downloader,
      }

      result = described_class.new(params).call

      expect(result.success?).to be(true)
      recording = Recording.first
      expect(recording.call_id).to eq(call.id)
      expect(recording.sid).to eq("1234")
      expect(recording.duration).to eq(100)
      expect(recording.audio).not_to be(nil)
    end

    it "does not create a recording if the call should not have the recording saved" do
      params = {
        call: double(save_recording?: false),
        sid: "1234",
        url: "https://api.twilio.com/cowbell.mp3",
        duration: "100",
        downloader: fake_downloader,
      }

      result = described_class.new(params).call

      expect(result.success?).to be(false)
      expect(Recording.count).to be(0)
      expect(ActiveStorage::Attachment.count).to be(0)
    end

    it "does not create a recording if the params are invalid" do
      call = create(:incoming_call)

      params = {
        call: call,
        url: "https://api.twilio.com/cowbell.mp3",
        duration: "100",
        downloader: fake_downloader,
      }

      result = described_class.new(params).call

      expect(result.success?).to be(false)
      expect(Recording.count).to be(0)
      expect(ActiveStorage::Attachment.count).to be(0)
    end

    it "does not create a recording if the file cannot be downloaded" do
      call = create(:incoming_call)

      params = {
        call: call,
        sid: "1234",
        url: "https://api.twilio.com/cowbell.mp3",
        duration: "100",
        downloader: double(from_url: Result.failure("fail")),
      }

      result = described_class.new(params).call

      expect(result.success?).to be(false)
      expect(Recording.count).to be(0)
      expect(ActiveStorage::Attachment.count).to be(0)
    end
  end

  def fake_downloader
    double(from_url: Result.success(
      file: open("./spec/fixtures/files/sample.mp3"),
      extension: ".mp3"
    ))
  end
end

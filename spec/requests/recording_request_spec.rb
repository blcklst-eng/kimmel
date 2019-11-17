require "rails_helper"

RSpec.describe "Recording Store API", :as_twilio, type: :request do
  describe "#store" do
    it "stores a recording a call" do
      use_fake_downloader
      call = create(:incoming_call)

      post recording_url(call), params: {
        RecordingSid: "ABCDEFG1234",
        RecordingUrl: "http://kimmel.com/recording.mp3",
        RecordingDuration: 10,
      }

      expect(response).to have_http_status(:created)
      recording = Recording.first
      expect(recording.call_id).to eq(call.id)
      expect(recording.sid).to eq("ABCDEFG1234")
      expect(recording.duration).to eq(10)
      expect(recording.audio).not_to be(nil)
    end
  end

  def use_fake_downloader
    downloader = spy(from_url: Result.success(
      file: open("./spec/fixtures/files/sample.mp3"),
      extension: ".mp3"
    ))
    stub_const("DownloadFile", downloader)
  end
end

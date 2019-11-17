require "rails_helper"

RSpec.describe "Voicemail Store API", :as_twilio, type: :request do
  describe "#store" do
    it "stores a voicemail recording for a existing incoming call" do
      use_fake_downloader
      participant = create(:participant)
      incoming_call = create(:incoming_call, participants: [participant])

      post voicemail_store_url(incoming_call), params: {
        CallSid: incoming_call.sid,
        RecordingUrl: "http://kimmel.com/recording.mp3",
        RecordingSid: "FAKESID123",
      }

      expect(response).to have_http_status(:created)
      voicemail = Voicemail.first
      expect(voicemail.voicemailable).to eq(incoming_call)
    end

    it "stores a voicemail recording for a existing ring group call" do
      use_fake_downloader
      call = create(:ring_group_call)

      post voicemail_store_url(call), params: {
        CallSid: call.from_sid,
        RecordingUrl: "http://kimmel.com/recording.mp3",
        RecordingSid: "FAKESID123",
      }

      expect(response).to have_http_status(:created)
      voicemail = Voicemail.first
      expect(voicemail.voicemailable).to eq(call)
    end

    it "does not store a voicemail recording with bad params" do
      call = create(:ring_group_call)

      post voicemail_store_url(call), params: {
        CallSid: "test",
        RecordingUrl: "http://kimmel.com/recording.mp3",
        RecordingSid: "FAKESID123",
      }

      expect(response).to have_http_status(:not_found)
      expect(Voicemail.count).to be(0)
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

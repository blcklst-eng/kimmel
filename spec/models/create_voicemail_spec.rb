require "rails_helper"

RSpec.describe CreateVoicemail, type: :model do
  describe "#call" do
    it "creates a voicemail for a incoming call" do
      incoming_call = create(:incoming_call)

      result = described_class.new(
        incoming_call: incoming_call,
        url: "https://api.twilio.com/cowbell.mp3",
        downloader: fake_downloader,
        recording_sid: "FAKESID123"
      ).call

      expect(result.success?).to be(true)
      voicemail = Voicemail.first
      expect(voicemail).not_to be(nil)
      expect(voicemail.voicemailable).to eq(incoming_call)
      expect(voicemail.audio).not_to be(nil)
      expect(ActiveStorage::Attachment.count).to be(1)
    end

    it "fails to create a voicemail if the download fails" do
      incoming_call = build_stubbed(:incoming_call)

      result = described_class.new(
        incoming_call: incoming_call,
        url: "https://api.twilio.com/cowbell.mp3",
        downloader: double(from_url: Result.failure("fail")),
        recording_sid: "FAKESID123"
      ).call

      expect(result.success?).to be(false)
      expect(Voicemail.count).to be(0)
      expect(ActiveStorage::Attachment.count).to be(0)
    end

    it "sends a new voicemail email if the user has it enabled" do
      user = create(:user, email_voicemails: true)
      incoming_call = create(:incoming_call, user: user)

      expect {
        described_class.new(
          incoming_call: incoming_call,
          url: "https://api.twilio.com/cowbell.mp3",
          downloader: fake_downloader,
          recording_sid: "FAKESID123"
        ).call
      }.to have_enqueued_job(SendNewVoicemailEmailJob)
    end

    it "does not send new voicemail email if user has it disabled" do
      user = create(:user, email_voicemails: false)
      incoming_call = create(:incoming_call, user: user)

      expect {
        described_class.new(
          incoming_call: incoming_call,
          url: "https://api.twilio.com/cowbell.mp3",
          downloader: fake_downloader,
          recording_sid: "FAKESID123"
        ).call
      }.not_to have_enqueued_job(SendNewVoicemailEmailJob)
    end
  end

  def fake_downloader
    double(from_url: Result.success(
      file: open("./spec/fixtures/files/sample.mp3"),
      extension: ".mp3"
    ))
  end
end

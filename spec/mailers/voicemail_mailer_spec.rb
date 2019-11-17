require "rails_helper"

RSpec.describe VoicemailMailer, type: :mailer do
  describe ".new_voicemail" do
    it "builds the mail" do
      user = create(:user)
      call = create(:incoming_call, :with_participant, user: user)
      voicemail = create(:voicemail, voicemailable: call, audio: ActiveStorageHelpers.create_audio_blob)

      mail = described_class.new_voicemail(voicemail: voicemail)
      expect(mail.subject).to eq("New Voicemail from #{voicemail.voicemailable.from_phone_number}")
      expect(mail.to).to include(voicemail.voicemailable.user.email)
      expect(mail.from).to include("voicemail@kimmel.com")
      expect(mail.body.encoded).to include("You have received a new voicemail.")
      expect(mail.attachments.length).to eq(1)
      expect(mail.attachments.first.content_type).to include("audio/wav")
      expect(mail.attachments.first.filename).to eq("voicemail-#{voicemail.created_at.to_i}.#{voicemail.audio.filename.extension}")
    end
  end
end

require "rails_helper"

RSpec.describe SendNewVoicemailEmailJob, type: :job do
  describe "#perform" do
    it "sends a email to the specified user" do
      user = create(:user)
      call = create(:incoming_call, :with_participant, user: user)
      voicemail = create(:voicemail, voicemailable: call)

      described_class.new.perform(voicemail.id)

      delivery = ActionMailer::Base.deliveries.last
      expect(delivery.to).to include(user.email)
      expect(delivery.attachments.length).to eq(1)
    end
  end
end

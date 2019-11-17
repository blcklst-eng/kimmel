require "rails_helper"

describe ParkParticipant, type: :model do
  describe "#call" do
    it "creates a new call and updates a previous call with twilio" do
      fake_adapter = spy
      stub_const("ConnectCallToConference", fake_adapter)

      participant = create(:participant)
      create(:incoming_call, participants: [participant])
      user = create(:user)

      result = described_class.new(
        participant: participant,
        user: user
      ).call

      new_call = Call.for_user(user).first
      expect(result.success?).to be(true)
      expect(new_call.in_state?(:initiated)).to be(true)
      expect(fake_adapter).to have_received(:new).with(
        call: new_call,
        sids: [participant.sid]
      )
      expect(fake_adapter).to have_received(:call)
    end
  end
end

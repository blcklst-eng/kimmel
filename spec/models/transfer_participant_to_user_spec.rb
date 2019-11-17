require "rails_helper"

RSpec.describe TransferParticipantToUser, type: :model do
  describe "#call" do
    it "updates a participant to a user" do
      fake_adapter = spy
      call = create(:incoming_call)
      participant = create(:participant, call: call)
      user = create(:user_with_number)

      result = described_class.new(
        participant: participant,
        user: user,
        adapter: fake_adapter
      ).call

      expect(result.success?).to be(true)
      expect(fake_adapter).to have_received(:update_call)
        .with(
          sid: participant.sid,
          url: RouteHelper.transfer_participant_url(
            to: user.phone_number,
            from: participant.phone_number
          )
        )
    end

    it "returns errors when it fails to update the participant" do
      fake_adapter = spy(update_call: false)
      call = create(:incoming_call)
      participant = create(:participant, call: call)
      user = create(:user_with_number)

      result = described_class.new(
        participant: participant,
        user: user,
        adapter: fake_adapter
      ).call

      expect(result.success?).to be(false)
      expect(result.errors).to include("Failed to update the call")
    end
  end
end

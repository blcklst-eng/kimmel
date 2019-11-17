require "rails_helper"

RSpec.describe "Transfer Participant Mutation API", :graphql do
  describe "transferParticipant" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: TransferParticipantInput!) {
          transferParticipant(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "updates the participant" do
      fake_adapter = stub_const("TwilioAdapter", spy)
      user = create(:user)
      call = create(:incoming_call, user: user)
      participant = create(:participant, call: call)
      transfer_to_user = create(:user_with_number)

      result = execute query, as: user, variables: {
        input: {
          participantId: participant.id,
          userId: transfer_to_user.id,
        },
      }

      success = result[:data][:transferParticipant][:success]
      expect(success).to be(true)
      expect(fake_adapter).to have_received(:update_call)
    end
  end
end

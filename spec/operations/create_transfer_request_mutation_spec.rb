require "rails_helper"

describe "Create Transfer Request Mutation API", :graphql do
  describe "createTransferRequest" do
    let(:query) do
      <<-GRAPHQL
        mutation($input: CreateTransferRequestInput!) {
          createTransferRequest(input: $input) {
            transferRequest {
              id
            }
          }
        }
      GRAPHQL
    end

    it "creates a transfer request for the participant" do
      operator = create(:user)
      call = create(:incoming_call, :with_participant, user: operator)
      recipient = create(:user)
      create(:incoming_call, :in_progress, user: recipient)

      result = execute query, as: operator, variables: {
        input: {
          userId: recipient.id,
          participantId: call.participants.first.id,
        },
      }

      expect(TransferRequest.count).to eq(1)
      transfer_request = result[:data][:createTransferRequest][:transferRequest]
      expect(transfer_request[:id]).not_to eq(nil)
    end
  end
end

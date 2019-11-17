require "rails_helper"

describe "Transfer Request Response Mutation API", :graphql do
  describe "transferRequestResponse" do
    let(:query) do
      <<-GRAPHQL
        mutation($input: TransferRequestResponseInput!) {
          transferRequestResponse(input: $input) {
            transferRequest {
              id
              response
            }
          }
        }
      GRAPHQL
    end

    it "updates the response to a transfer request" do
      user = create(:user)
      transfer_request = create(:transfer_request, receiver: user)
      response = "Park them for me"

      result = execute query, as: user, variables: {
        input: {
          id: transfer_request.id,
          response: response,
        },
      }

      request = result[:data][:transferRequestResponse][:transferRequest]
      expect(request[:response]).to eq(response)
      expect(transfer_request.reload.response).to eq(response)
    end
  end
end

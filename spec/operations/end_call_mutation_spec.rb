require "rails_helper"

describe "End Call Mutation API", :graphql do
  describe "endCall" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: EndCallInput!) {
          endCall(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "ends a call" do
      adapter = stub_const("TwilioAdapter", spy(end_conference: true))
      user = create(:user_with_number)
      call = create(:outgoing_call, :in_progress, user: user)

      result = execute query, as: user, variables: {
        input: {
          callId: call.id,
        },
      }

      end_call_result = result[:data][:endCall]
      expect(end_call_result[:success]).to be(true)
      expect(adapter).to have_received(:end_conference)
    end
  end
end

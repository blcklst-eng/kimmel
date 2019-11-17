require "rails_helper"

describe "Rejoin Call Mutation API", :graphql do
  describe "rejoinCall" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: RejoinCallInput!) {
          rejoinCall(input: $input) {
            call {
              sid
            }
          }
        }
      GRAPHQL
    end

    it "rejoins an active call" do
      call_result = CallResult.new(connected?: true, sid: "fake-sid")
      adapter = stub_const("TwilioAdapter", spy(create_call: call_result))
      user = create(:user_with_number)
      call = create(:outgoing_call, :in_progress, user: user)

      result = execute query, as: user, variables: {
        input: {
          callId: call.id,
        },
      }

      rejoin_call_result = result[:data][:rejoinCall][:call]
      expect(rejoin_call_result[:sid]).to eq("fake-sid")
      expect(adapter).to have_received(:create_call)
    end
  end
end

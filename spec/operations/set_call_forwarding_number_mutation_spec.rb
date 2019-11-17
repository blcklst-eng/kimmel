require "rails_helper"

describe "Set Call Forwarding Number Muation API", :graphql do
  describe "setCallForwardingNumber" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: SetCallForwardingNumberInput!) {
          setCallForwardingNumber(input: $input) {
            user {
              callForwardingNumber
            }
          }
        }
      GRAPHQL
    end

    it "sets a call forwarding number" do
      fake_adapter = spy(lookup: LookupResult.new(phone_number: "+13159559883"))
      stub_const("TwilioAdapter", fake_adapter)
      user = create(:user, call_forwarding_number: nil)

      execute query, as: user, variables: {
        input: {
          number: "3159559883",
        },
      }

      user.reload
      expect(user.call_forwarding_number).to eq("+13159559883")
    end
  end
end

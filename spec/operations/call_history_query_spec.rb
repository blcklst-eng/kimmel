require "rails_helper"

describe "Call History Query API", :graphql do
  describe "callHistory" do
    let(:query) do
      <<~'GRAPHQL'
        query($phoneNumber: PhoneNumber!) {
          callHistory(phoneNumber: $phoneNumber) {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets calls involving a specific phone number" do
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: "+18282519900")))
      contact = create(:contact, phone_number: "+18282519900")
      participant = create(:participant, contact: contact)
      call = create(:incoming_call, participants: [participant])

      result = execute query, as: build(:user), variables: {
        phoneNumber: "828-251-9900",
      }

      nodes = result[:data][:callHistory][:edges].pluck(:node)
      expect(nodes).to include(id: call.id.to_s)
    end
  end
end

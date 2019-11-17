require "rails_helper"

describe "Conversation History Query API", :graphql do
  describe "conversationHistory" do
    let(:query) do
      <<~'GRAPHQL'
        query($phoneNumber: PhoneNumber!) {
          conversationHistory(phoneNumber: $phoneNumber) {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets conversations involving a specific phone number" do
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: "+18282519900")))
      contact = create(:contact, phone_number: "+18282519900")
      conversation = create(:conversation, contact: contact)

      result = execute query, as: build(:user), variables: {
        phoneNumber: "828-251-9900",
      }

      nodes = result[:data][:conversationHistory][:edges].pluck(:node)
      expect(nodes).to include(id: conversation.id.to_s)
    end
  end
end

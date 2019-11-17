require "rails_helper"

describe "Update Contact Mutation API", :graphql do
  describe "updateContact" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: UpdateContactInput!) {
          updateContact(input: $input) {
            contact {
              firstName
              phoneNumber
            }
          }
        }
      GRAPHQL
    end

    it "updates an existing contact" do
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: "+18282519900")))
      user = create(:user_with_number)
      contact = create(:contact, user: user, first_name: "Original name")

      result = execute query, as: user, variables: {
        input: {
          id: contact.id,
          contactInput: {
            firstName: "Updated name",
            phoneNumber: "(828) 251-9900",
          },
        },
      }

      contact_result = result[:data][:updateContact][:contact]
      expect(contact_result[:firstName]).to eq("Updated name")
      expect(contact.reload.first_name).to eq("Updated name")
      expect(contact_result[:phoneNumber]).to eq("+18282519900")
      expect(contact.reload.phone_number).to eq("+18282519900")
    end
  end
end

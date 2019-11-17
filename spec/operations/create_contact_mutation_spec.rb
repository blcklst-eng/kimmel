require "rails_helper"

describe "Create Contact Mutation API", :graphql do
  describe "createContact" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: CreateContactInput!) {
          createContact(input: $input) {
            contact {
              firstName
              lastName
              phoneNumber
            }
          }
        }
      GRAPHQL
    end

    it "makes a new contact" do
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: "+18282519900")))
      user = build(:user)

      result = execute query, as: user, variables: {
        input: {
          contactInput: {
            firstName: "John",
            lastName: "Doe",
            phoneNumber: "(828) 251-9900",
          },
        },
      }

      expect(Contact.count).to eq(1)
      first_name = result[:data][:createContact][:contact][:firstName]
      phone_number = result[:data][:createContact][:contact][:phoneNumber]
      expect(first_name).to eq("John")
      expect(phone_number).to eq("+18282519900")
    end

    it "updates a existing contact with a name" do
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: "+18282519900")))
      user = build(:user)
      contact = create(:contact, :unsaved, user: user, phone_number: "+18282519900")

      result = execute query, as: user, variables: {
        input: {
          contactInput: {
            firstName: "John",
            lastName: "Doe",
            phoneNumber: "(828) 251-9900",
          },
        },
      }

      first_name = result[:data][:createContact][:contact][:firstName]
      expect(first_name).to eq("John")
      contact = contact.reload
      expect(contact.first_name).to eq("John")
      expect(contact.last_name).to eq("Doe")
    end
  end
end

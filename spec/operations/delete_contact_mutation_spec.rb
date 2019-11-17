require "rails_helper"

describe "Delete Contact Mutation API", :graphql do
  describe "deleteContact" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: DeleteContactInput!) {
          deleteContact(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "changes the specified contact to unsaved" do
      user = create(:user_with_number)
      contact = create(:contact, :saved, user: user)

      result = execute query, as: user, variables: {
        input: {
          id: contact.id,
        },
      }

      expect(result[:data][:deleteContact][:success]).to be(true)
      expect(contact.reload.saved).to be(false)
    end
  end
end

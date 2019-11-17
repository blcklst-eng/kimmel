require "rails_helper"

describe "Remove Contact From Saved Mutation API", :graphql do
  describe "removeContactFromSaved" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: RemoveContactFromSavedInput!) {
          removeContactFromSaved(input: $input) {
            contact {
              id
            }
          }
        }
      GRAPHQL
    end

    it "changes the specified contact to unsaved" do
      user = create(:user_with_number)
      contact = create(:contact, :saved, user: user)

      execute query, as: user, variables: {
        input: {
          id: contact.id,
        },
      }

      expect(contact.reload.saved).to be(false)
    end
  end
end

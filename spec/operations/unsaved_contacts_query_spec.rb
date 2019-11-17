require "rails_helper"

describe "Unsaved Contacts Query API", :graphql do
  describe "unsavedContacts" do
    let(:query) do
      <<~'GRAPHQL'
        query {
          unsavedContacts {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets contacts for the current user that are not saved" do
      user = create(:user)
      unsaved_contact = create(:contact, :unsaved, user: user)
      create(:conversation, user: user, contact: unsaved_contact)
      saved_contact = create(:contact, user: user)

      result = execute query, as: user

      nodes = result[:data][:unsavedContacts][:edges].pluck(:node)
      expect(nodes).to include(id: unsaved_contact.id.to_s)
      expect(nodes).not_to include(id: saved_contact.id.to_s)
    end
  end
end

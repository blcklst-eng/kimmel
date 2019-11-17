require "rails_helper"

describe "Contacts Query API", :graphql do
  describe "contacts" do
    let(:query) do
      <<~'GRAPHQL'
        query($sortBy: ContactSortByType, $sortOrder: SortOrderType) {
          contacts(sortBy: $sortBy, sortOrder: $sortOrder) {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets only saved contacts for the current user" do
      user = create(:user)
      contact = create(:contact, :saved, user: user)
      another_contact = create(:contact, :saved)

      result = execute query, as: user

      nodes = result[:data][:contacts][:edges].pluck(:node)
      expect(nodes).to include(id: contact.id.to_s)
      expect(nodes).not_to include(id: another_contact.id.to_s)
    end

    it "can sort the contacts" do
      user = create(:user)
      contact_one = create(:contact, :saved, user: user, company: "b")
      contact_two = create(:contact, :saved, user: user, company: "a")

      result = execute query, as: user, variables: {
        sortBy: "COMPANY",
        sortOrder: "ASC",
      }

      edges = result[:data][:contacts][:edges]
      expect(edges[0][:node][:id].to_i).to eq(contact_two.id)
      expect(edges[1][:node][:id].to_i).to eq(contact_one.id)
    end
  end
end

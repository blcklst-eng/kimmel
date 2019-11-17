require "rails_helper"

describe "Templates Query API", :graphql do
  describe "templates" do
    let(:query) do
      <<-'GRAPHQL'
        query {
          templates {
            edges {
              node {
                body
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets all user relevant templates" do
      user = create(:user)
      template = create(:template, body: "A unique body...", user: user)
      another_template = create(:template)

      result = execute query, as: user

      nodes = result[:data][:templates][:edges].pluck(:node)
      expect(nodes).to include(body: template.body)
      expect(nodes).not_to include(body: another_template.body)
    end
  end
end

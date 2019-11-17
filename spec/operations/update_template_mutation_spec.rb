require "rails_helper"

describe "Update Tempate Mutation API", :graphql do
  describe "updateTemplate" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: UpdateTemplateInput!) {
          updateTemplate(input: $input) {
            template {
              body
              tags
            }
          }
        }
      GRAPHQL
    end

    it "updates an existing owned template" do
      user = create(:user)
      template = create(:template, user: user, body: "This is the original template")

      result = execute query, as: user, variables: {
        input: {
          id: template.id,
          templateInput: {
            body: "This is the new body",
            tags: %w[new tag],
          },
        },
      }

      template = result[:data][:updateTemplate][:template]
      body = template[:body]
      tags = template[:tags]
      expect(body).to eq("This is the new body")
      expect(tags).to include("new")
      expect(tags).to include("tag")
    end
  end
end

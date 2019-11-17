require "rails_helper"

describe "Create Template Mutation API", :graphql do
  describe "createTemplate" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: CreateTemplateInput!) {
          createTemplate(input: $input) {
            template {
              tags
              body
            }
          }
        }
      GRAPHQL
    end

    it "makes a new template" do
      user = build(:user)

      vars = {
        input: {
          templateInput: {
            tags: %w[onboard],
            body: "This is a sample body for onboarding a new client.",
          },
        },
      }

      result = execute query, as: user, variables: vars

      expect(Template.count).to eq(1)
      template = result[:data][:createTemplate][:template]
      tags = template[:tags]
      expect(tags.count).to eq(1)
      expect(template[:body]).to eq("This is a sample body for onboarding a new client.")
    end
  end
end

require "rails_helper"

describe "Create Global Template Mutation API", :graphql do
  describe "createTemplate" do
    let(:query) do
      <<-'GRAPHQL'
        mutation($input: CreateGlobalTemplateInput!) {
          createGlobalTemplate(input: $input) {
            template {
              tags
              body
            }
          }
        }
      GRAPHQL
    end

    it "makes a new global template" do
      user = build(:user, :admin)

      vars = {
        input: {
          templateInput: {
            tags: %w[onboard new],
            body: "This is a sample body for onboarding a new client.",
          },
        },
      }

      result = execute query, as: user, variables: vars

      expect(Template.count).to eq(1)
      template = result[:data][:createGlobalTemplate][:template]
      tags = template[:tags]
      expect(tags.count).to eq(2)
      expect(template[:body]).to eq("This is a sample body for onboarding a new client.")
    end
  end
end

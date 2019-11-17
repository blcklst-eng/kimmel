require "rails_helper"

describe "Delete Template Mutation API", :graphql do
  describe "deleteTemplate" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: DeleteTemplateInput!) {
          deleteTemplate(input: $input) {
            success
          }
        }
      GRAPHQL
    end

    it "deletes the specified template" do
      user = create(:user)
      template = create(:template, user: user)

      result = execute query, as: user, variables: {
        input: {
          id: template.id,
        },
      }

      expect(result[:data][:deleteTemplate][:success]).to be(true)
      expect(template.reload.deleted_at).not_to be(nil)
    end

    it "deletes global template if user is admin" do
      admin = create(:user, :admin)
      template = create(:global_template)

      result = execute query, as: admin, variables: {
        input: {
          id: template.id,
        },
      }

      expect(result[:data][:deleteTemplate][:success]).to be(true)
      expect(template.reload.deleted_at).not_to be(nil)
    end
  end
end

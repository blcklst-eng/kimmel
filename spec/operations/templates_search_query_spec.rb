require "rails_helper"

describe "Templates Search Query API", :graphql do
  describe "templatesSearch" do
    let(:query) do
      <<-'GRAPHQL'
      query($tag: String!) {
        templatesSearch(tag: $tag) {
          body
          tags
        }
      }
      GRAPHQL
    end

    it "gets only templates for current user" do
      user = create(:user)
      create(:template, user: user, tags: ["testing"])

      another_user = create(:user)
      create(:template, user: another_user, tags: ["testing"])

      result = execute query, as: user, variables: {
        tag: "test",
      }

      templates = result[:data][:templatesSearch]
      expect(templates.count).to eq(1)
    end

    it "gets templates for user and global templates" do
      user = create(:user)
      create(:template, user: user, tags: ["testing"])
      create(:global_template, tags: ["testing"])

      result = execute query, as: user, variables: {
        tag: "test",
      }

      templates = result[:data][:templatesSearch]
      expect(templates.count).to eq(2)
    end
  end
end

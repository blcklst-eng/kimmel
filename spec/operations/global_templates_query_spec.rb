require "rails_helper"

describe "Global Templates Search Query API", :graphql do
  describe "globalTemplatesSearch" do
    let(:query) do
      <<-'GRAPHQL'
      query($tag: String!) {
        globalTemplatesSearch(tag: $tag) {
          body
          tags
        }
      }
      GRAPHQL
    end

    it "gets global templates" do
      create(:global_template, tags: ["testing"])

      result = execute query, as: build(:user), variables: {
        tag: "test",
      }

      templates = result[:data][:globalTemplatesSearch]
      expect(templates.count).to eq(1)
    end

    it "does not get user templates" do
      user = create(:user)
      create(:template, user: user, tags: ["testing"])

      result = execute query, as: build(:user), variables: {
        tag: "test",
      }

      templates = result[:data][:globalTemplatesSearch]
      expect(templates.count).to eq(0)
    end
  end
end

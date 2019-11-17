require "rails_helper"

describe "Template Query API", :graphql do
  describe "template" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          template(id: $id) {
            body
            tags
          }
        }
      GRAPHQL
    end

    it "gets the specified template" do
      user = create(:user)
      template = create(:template, user: user)

      result = execute query, as: user, variables: {id: template.id}

      body = result[:data][:template][:body]
      expect(body).to eq(template.body)
    end

    it "gets a global template" do
      template = create(:global_template)

      result = execute query, as: build(:user), variables: {id: template.id}

      body = result[:data][:template][:body]
      expect(body).to eq(template.body)
    end
  end
end

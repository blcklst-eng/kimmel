require "rails_helper"

RSpec.describe RouteHelper do
  it "delegates to rails url helpers" do
    result = RouteHelper.graphql_path

    expect(result).to eq("/graphql")
  end
end

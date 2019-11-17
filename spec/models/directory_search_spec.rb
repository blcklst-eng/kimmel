require "rails_helper"

RSpec.describe DirectorySearch, :search do
  describe "#search" do
    it "searches on user name" do
      user = create(:user_with_number, first_name: "john", last_name: "doe")
      reindex_search(User)
      search = described_class.new(query: "john doe")

      results = search.results

      expect(results.first).to eq(user)
    end

    it "handles name misspellings with an edit distance of 2" do
      user = create(:user_with_number, first_name: "john", last_name: "doe")
      reindex_search(User)
      search = described_class.new(query: "jaahn doe")

      results = search.results

      expect(results.first).to eq(user)
    end

    it "searches in the middle of a user's name" do
      user = create(:user_with_number, first_name: "john", last_name: "doe")
      reindex_search(User)
      search = described_class.new(query: "doe")

      results = search.results

      expect(results.first).to eq(user)
    end

    it "searches on user id" do
      user = create(:user_with_number)
      reindex_search(User)
      search = described_class.new(query: user.id)

      results = search.results

      expect(results).to include(user)
    end
  end
end

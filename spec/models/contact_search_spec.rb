require "rails_helper"

RSpec.describe ContactSearch, :search do
  describe "#search" do
    it "searches on contact name" do
      user = create(:user)
      contact = create(:contact, user: user, first_name: "John", last_name: "Doe")
      reindex_search(contact)
      search = described_class.new(query: "john doe", user: user)

      results = search.results

      expect(results.first).to eq(contact)
    end

    it "handles name misspellings with an edit distance of 2" do
      user = create(:user)
      contact = create(:contact, user: user, first_name: "John", last_name: "Doe")
      reindex_search(contact)
      search = described_class.new(query: "jaahn doe", user: user)

      results = search.results

      expect(results.first).to eq(contact)
    end

    it "searches in the middle of a contacts's name" do
      user = create(:user)
      contact = create(:contact, user: user, first_name: "John", last_name: "Doe")
      reindex_search(contact)
      search = described_class.new(query: "doe", user: user)

      results = search.results

      expect(results.first).to eq(contact)
    end

    it "searches on contact number" do
      user = create(:user)
      contact = create(:contact, user: user, phone_number: "+18282555500")
      reindex_search(contact)
      search = described_class.new(query: "828", user: user)

      results = search.results

      expect(results).to include(contact)
    end

    it "only searches on saved contacts" do
      user = create(:user)
      unsaved_contact = create(:contact, :unsaved, user: user, last_name: "Doe")
      saved_contact = create(:contact, :saved, user: user, last_name: "Doe")
      reindex_search(Contact)
      search = described_class.new(query: "Doe", user: user)

      results = search.results

      expect(results).to include(saved_contact)
      expect(results).not_to include(unsaved_contact)
    end

    it "does not search contacts for other users" do
      user = build_stubbed(:user)
      create(:contact, last_name: "Doe")
      reindex_search(Contact)
      search = described_class.new(query: "Doe", user: user)

      results = search.results

      expect(results).to be_empty
    end
  end
end

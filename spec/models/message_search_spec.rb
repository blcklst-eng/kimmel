require "rails_helper"

RSpec.describe MessageSearch, :search do
  describe "#search" do
    it "searches on message body" do
      user = create(:user)
      conversation = create(:conversation, user: user)
      message = create(:incoming_message, body: "Test message", conversation: conversation)
      reindex_search(message)
      search = described_class.new(query: "message", user: user)

      results = search.results

      expect(results.first).to eq(message)
    end

    it "searches messages the user has sent or received" do
      user = create(:user)
      conversation = create(:conversation, user: user)
      incoming_message = create(:incoming_message, body: "test", conversation: conversation)
      outgoing_message = create(:outgoing_message, body: "another test", conversation: conversation)
      another_users_message = create(:incoming_message, body: "test message")
      reindex_search(Message)
      search = described_class.new(query: "test", user: user)

      results = search.results

      expect(results).to include(incoming_message)
      expect(results).to include(outgoing_message)
      expect(results).not_to include(another_users_message)
    end

    it "does not search messages the user is not associated with" do
      user = build_stubbed(:user)
      create(:incoming_message, body: "Test message")
      reindex_search(Message)
      search = described_class.new(query: "message", user: user)

      results = search.results

      expect(results).to be_empty
    end
  end
end

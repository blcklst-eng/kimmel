require "rails_helper"

RSpec.describe Conversation, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:conversation)).to be_valid
    end
  end

  describe ".most_recent_message" do
    it "gets the most recent message in the conversation" do
      conversation = create(:conversation)
      create(:incoming_message, conversation: conversation, created_at: 10.days.ago)
      newer_message = create(:incoming_message, conversation: conversation, created_at: 1.day.ago)

      result = conversation.most_recent_message

      expect(result).to eq(newer_message)
    end
  end

  describe ".for_user" do
    it "returns conversations involving the user" do
      user = create(:user)
      conversation = create(:conversation, user: user)

      result = described_class.for_user(user).first

      expect(result).to eq(conversation)
    end

    it "does not return conversations involving other users" do
      user = create(:user)
      conversation = create(:conversation)

      result = described_class.for_user(user).first

      expect(result).not_to eq(conversation)
    end
  end

  describe ".with_contact_phone_number" do
    it "gets conversations with the specified phone number" do
      contact = create(:contact, phone_number: "+11231231234")
      conversation = create(:conversation, contact: contact)

      result = described_class.with_contact_phone_number("+11231231234")

      expect(result).to include(conversation)
    end
  end

  describe ".unread" do
    it "finds conversations that are not read" do
      conversation = create(:conversation, :unread)

      result = described_class.unread.first

      expect(result).to eq(conversation)
    end

    it "does not find read conversations" do
      create(:conversation, :read)

      result = described_class.unread.first

      expect(result).to be(nil)
    end
  end

  describe ".order_by_most_recent_message" do
    it "sorts the conversations by the most recent message" do
      first = create(:conversation, last_message_at: 1.day.ago)
      second = create(:conversation, last_message_at: Time.current)

      ordered_conversations = described_class.order_by_most_recent_message

      expect(ordered_conversations.first).to eq(second)
      expect(ordered_conversations.second).to eq(first)
    end
  end

  describe "#read_messages" do
    it "sets an unread conversation to read" do
      conversation = build(:conversation, :unread)

      result = conversation.read_messages

      expect(result).to be(true)
      expect(conversation.read).to be(true)
    end

    it "does nothing to a conversation that has already been read" do
      conversation = build(:conversation, :read)

      result = conversation.read_messages

      expect(result).to be(true)
      expect(conversation.read).to be(true)
    end

    it "queues up a broadcast count job" do
      conversation = build(:conversation, :read)

      expect {
        conversation.read_messages
      }.to have_enqueued_job(BroadcastCountsJob)
    end
  end

  describe "#message_received" do
    it "sets an read conversation to unread" do
      conversation = build(:conversation, :read)

      result = conversation.message_received

      expect(result).to be(true)
      expect(conversation.read).to be(false)
    end

    it "does nothing to a conversation that is already unread" do
      conversation = build(:conversation, :unread)

      result = conversation.message_received

      expect(result).to be(true)
      expect(conversation.read).to be(false)
    end

    it "queues up a broadcast count job" do
      conversation = build(:conversation, :read)

      expect {
        conversation.read_messages
      }.to have_enqueued_job(BroadcastCountsJob)
    end
  end

  describe ".unread_count" do
    it "shows the right count" do
      conversation = create(:conversation, :unread)
      create(:conversation, user: conversation.user, read: true)

      result = Conversation.for_user(conversation.user).unread_count

      expect(result).to be(1)
    end
  end
end

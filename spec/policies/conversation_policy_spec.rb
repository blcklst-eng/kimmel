require "rails_helper"

RSpec.describe ConversationPolicy do
  describe "#view?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user_with_number, :admin)
      conversation = build_stubbed(:conversation)
      policy = described_class.new(user, conversation)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns true for a user is involved in the conversation" do
      user = build_stubbed(:user_with_number)
      conversation = build_stubbed(:conversation, user: user)
      policy = described_class.new(user, conversation)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns false if the user does not have a number" do
      user = build_stubbed(:user)
      conversation = build_stubbed(:conversation, user: user)
      policy = described_class.new(user, conversation)

      result = policy.view?

      expect(result).to be(false)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user_with_number)
      conversation = build_stubbed(:conversation)
      policy = described_class.new(user, conversation)

      result = policy.view?

      expect(result).to be(false)
    end
  end
end

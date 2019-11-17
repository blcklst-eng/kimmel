require "rails_helper"

RSpec.describe MessagePolicy do
  describe "#retry?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user_with_number, :admin)
      contact = build_stubbed(:contact)
      policy = described_class.new(user, contact)

      result = policy.retry?

      expect(result).to be(true)
    end

    it "returns true for a user that sent the message" do
      user = build_stubbed(:user_with_number)
      contact = build_stubbed(:contact, user: user)
      policy = described_class.new(user, contact)

      result = policy.retry?

      expect(result).to be(true)
    end

    it "returns false for a user without a number" do
      user = build_stubbed(:user)
      contact = build_stubbed(:contact, user: user)
      policy = described_class.new(user, contact)

      result = policy.retry?

      expect(result).to be(false)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user_with_number)
      contact = build_stubbed(:contact)
      policy = described_class.new(user, contact)

      result = policy.retry?

      expect(result).to be(false)
    end
  end
end

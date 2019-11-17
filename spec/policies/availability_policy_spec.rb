require "rails_helper"

RSpec.describe AvailabilityPolicy do
  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user_with_number, :admin)
      policy = described_class.new(user, user)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns true for the user" do
      user = build_stubbed(:user_with_number)
      policy = described_class.new(user, user)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user_with_number)
      policy = described_class.new(build_stubbed(:user), user)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end

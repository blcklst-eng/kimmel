require "rails_helper"

RSpec.describe UserPolicy do
  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      other_user = build_stubbed(:user)
      policy = described_class.new(user, other_user)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      other_user = build_stubbed(:user)
      policy = described_class.new(user, other_user)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end

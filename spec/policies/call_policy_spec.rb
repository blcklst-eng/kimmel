require "rails_helper"

RSpec.describe CallPolicy do
  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      call = build_stubbed(:call)
      policy = described_class.new(user, call)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns true for a user that owns the call" do
      user = build_stubbed(:user)
      call = build_stubbed(:call, user: user)
      policy = described_class.new(user, call)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      call = build_stubbed(:call)
      policy = described_class.new(user, call)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end

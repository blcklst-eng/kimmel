require "rails_helper"

RSpec.describe RingGroupPolicy do
  describe "#view?" do
    it "returns true for members of the ring group" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      policy = described_class.new(user, ring_group)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      ring_group = build_stubbed(:ring_group)
      policy = described_class.new(user, ring_group)

      result = policy.view?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      ring_group = build_stubbed(:ring_group)
      policy = described_class.new(user, ring_group)

      result = policy.view?

      expect(result).to be(false)
    end
  end

  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      ring_group = build_stubbed(:ring_group)
      policy = described_class.new(user, ring_group)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      ring_group = build_stubbed(:ring_group)
      policy = described_class.new(user, ring_group)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end

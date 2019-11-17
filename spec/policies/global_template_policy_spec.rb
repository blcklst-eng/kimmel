require "rails_helper"

RSpec.describe GlobalTemplatePolicy do
  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      template = build_stubbed(:template)
      policy = described_class.new(user, template)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      template = build_stubbed(:template)
      policy = described_class.new(user, template)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end

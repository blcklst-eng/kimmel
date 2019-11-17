require "rails_helper"

RSpec.describe PhoneNumberPolicy do
  describe "#manage?" do
    it "returns true for an admin user" do
      user = build_stubbed(:user, :admin)
      phone_number = build_stubbed(:phone_number)
      policy = described_class.new(user, phone_number)

      result = policy.manage?

      expect(result).to be(true)
    end

    it "returns false for a user without permission" do
      user = build_stubbed(:user)
      phone_number = build_stubbed(:phone_number)
      policy = described_class.new(user, phone_number)

      result = policy.manage?

      expect(result).to be(false)
    end
  end
end

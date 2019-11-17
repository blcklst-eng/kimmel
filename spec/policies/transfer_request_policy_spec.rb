require "rails_helper"

describe TransferRequestPolicy do
  describe "#manage?" do
    it "returns true if the user is the recipient" do
      user = build_stubbed(:user)
      transfer_request = build_stubbed(:transfer_request, receiver: user)
      policy = described_class.new(user, transfer_request)

      result = policy.respond?

      expect(result).to be(true)
    end

    it "returns false if the user is the recipient" do
      user = build_stubbed(:user)
      transfer_request = build_stubbed(:transfer_request)
      policy = described_class.new(user, transfer_request)

      result = policy.respond?

      expect(result).to be(false)
    end
  end
end

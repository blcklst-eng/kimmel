require "rails_helper"

RSpec.describe Unassigned do
  it_should_behave_like "an assignable"

  describe "#present?" do
    it "is not present" do
      result = described_class.new.present?

      expect(result).to be(false)
    end
  end

  describe "#receive_incoming_call" do
    it "returns a message indicating the number is invalid" do
      result = described_class.new.receive_incoming_call

      expect(result.success?).to be(true)
      expect(result.response).to eq(InvalidPhoneNumberResponse.new.to_s)
    end
  end

  describe "#receive_transfer_request_call" do
    it "cannot take a transfer request" do
      result = described_class.new.receive_transfer_request_call

      expect(result.success?).to be(false)
    end
  end

  describe "#last_communication_at" do
    it "it returns nil" do
      result = described_class.new.last_communication_at

      expect(result).to be_nil
    end
  end
end

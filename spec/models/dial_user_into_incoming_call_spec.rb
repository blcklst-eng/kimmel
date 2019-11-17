require "rails_helper"

RSpec.describe DialUserIntoIncomingCall do
  describe "#call" do
    it "updates the call when the connection succeeds" do
      incoming_call = create(:incoming_call, :with_participant)
      stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

      result = described_class.new(
        incoming_call
      ).call

      expect(result.success?).to be(true)
      expect(incoming_call.sid).to eq("1234")
      expect(incoming_call.in_state?(:initiated)).to be(true)
    end

    it "marks the call as failed when the connection does not succeed" do
      incoming_call = create(:incoming_call, :with_participant)
      stub_const("ConnectCall", spy(call: Result.failure("failed")))

      result = described_class.new(
        incoming_call
      ).call

      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
      expect(incoming_call.in_state?(:failed)).to be(true)
    end
  end
end

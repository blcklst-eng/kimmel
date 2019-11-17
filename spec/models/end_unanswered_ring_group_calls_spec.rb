require "rails_helper"

RSpec.describe EndUnansweredRingGroupCalls do
  describe "#call" do
    it "ends ring group calls other than the answered call" do
      twilio_adapter = spy(cancel_call: true)

      ring_group_call = create(:ring_group_call)
      answered_call = create(:incoming_call, :in_progress, ring_group_call: ring_group_call)
      other_call = create(:incoming_call, :initiated, ring_group_call: ring_group_call)

      result = described_class.new(
        answered_call: answered_call, adapter: twilio_adapter
      ).call

      expect(result.success?).to be(true)
      expect(twilio_adapter).to have_received(:cancel_call).with(other_call.sid).once
      expect(other_call.reload.in_state?(:canceled)).to be(true)
    end

    it "returns an error if the answered call is not actually active" do
      call = create(:incoming_call, :completed)

      result = described_class.new(
        answered_call: call
      ).call

      expect(result.success?).to be(false)
    end
  end
end

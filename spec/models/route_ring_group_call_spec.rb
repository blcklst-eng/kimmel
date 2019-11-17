require "rails_helper"

RSpec.describe RouteRingGroupCall do
  describe "#call" do
    it "sets the call to no answer when it is not answered" do
      call = create(:incoming_call)

      described_class.new(
        status: CallStatus.new(:no_answer),
        call: call
      ).call

      expect(call.in_state?(:no_answer)).to be(true)
    end

    it "connects the call to the conference when a call is answered" do
      conference = stub_const("ConnectCallToConference", spy(call: Result.success))

      ring_group_call = create(:ring_group_call)
      call = create(:incoming_call, ring_group_call: ring_group_call)

      described_class.new(
        status: CallStatus.new(:in_progress),
        call: call
      ).call

      expect(conference).to have_received(:call)
    end

    it "ends other ring group calls when one is answered" do
      stub_const("ConnectCallToConference", spy(call: Result.success))
      end_call = stub_const("EndUnansweredRingGroupCalls", spy(call: Result.success))

      ring_group_call = create(:ring_group_call)
      call = create(:incoming_call, ring_group_call: ring_group_call)

      described_class.new(
        status: CallStatus.new(:in_progress),
        call: call
      ).call

      expect(end_call).to have_received(:new).with(answered_call: call).once
      expect(end_call).to have_received(:call).once
    end
  end
end

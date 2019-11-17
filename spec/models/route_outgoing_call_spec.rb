require "rails_helper"

RSpec.describe RouteOutgoingCall do
  describe "#call" do
    it "ends the outgoing call when it is not answered" do
      call = create(:outgoing_call)
      adapter = spy

      described_class.new(
        status: CallStatus.new(:no_answer),
        call: call,
        adapter: adapter
      ).call

      expect(call.in_state?(:no_answer)).to be(true)
      expect(adapter).to have_received(:end_call).with(call.sid)
    end

    it "connects to the conference when a call is answered" do
      call = create(:outgoing_call)
      conference = stub_const("ConnectCallToConference", spy(call: Result.success))

      described_class.new(
        status: CallStatus.new(:in_progress),
        call: call
      ).call

      expect(conference).to have_received(:call)
    end
  end
end

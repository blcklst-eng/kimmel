require "rails_helper"

RSpec.describe RouteIncomingCall do
  describe "#call" do
    it "sends the incoming call to voicemail when it was not answered" do
      call = create(:incoming_call)
      voicemail = stub_const("ConnectCallToVoicemail", spy(call: Result.success))

      described_class.new(
        status: CallStatus.new(:no_answer),
        call: call
      ).call

      expect(voicemail).to have_received(:call)
      expect(call.in_state?(:no_answer)).to be(true)
    end

    it "connects to the conference when a call is answered" do
      call = create(:incoming_call)
      create(:participant, call: call)
      conference = stub_const("ConnectCallToConference", spy(call: Result.success))

      described_class.new(
        status: CallStatus.new(:in_progress),
        call: call
      ).call

      expect(conference).to have_received(:call)
    end
  end
end

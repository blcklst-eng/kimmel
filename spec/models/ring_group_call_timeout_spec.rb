require "rails_helper"

RSpec.describe RingGroupCallTimeout do
  describe "#call" do
    it "marks the ring group call as missed and redirects to voicemail if no one answered" do
      ring_group_call = create(:ring_group_call)
      voicemail = stub_const("ConnectCallToVoicemail", spy(call: Result.success))

      described_class.new(ring_group_call).call

      expect(ring_group_call).to be_missed
      expect(voicemail).to have_received(:call)
    end

    it "does nothing if one of the ring group calls was answered" do
      ring_group_call = create(:ring_group_call)
      create(:incoming_call, :in_progress, ring_group_call: ring_group_call)
      voicemail = stub_const("ConnectCallToVoicemail", spy)

      described_class.new(ring_group_call).call

      expect(ring_group_call).not_to be_missed
      expect(voicemail).not_to have_received(:call)
    end
  end
end

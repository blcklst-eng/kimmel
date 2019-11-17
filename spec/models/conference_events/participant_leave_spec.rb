require "rails_helper"

RSpec.describe ConferenceEvents::ParticipantLeave do
  describe "#apply" do
    it "updates a single participants status to completed if other participants are still active" do
      call = create(:incoming_call)
      participant = create(:participant, call: call, status: :in_progress)
      create(:participant, call: call, status: :in_progress)

      described_class.new(sid: participant.sid).apply(call)

      expect(participant.reload.status).to eq("completed")
    end

    it "ends the conference if no participants are left" do
      call = create(:incoming_call, :in_progress)
      participant = create(:participant, call: call, status: :in_progress)
      adapter = stub_const("TwilioAdapter", spy(end_conference: true))

      described_class.new(sid: participant.sid).apply(call)

      expect(participant.reload.status).to eq("completed")
      expect(adapter).to have_received(:end_conference)
    end
  end
end

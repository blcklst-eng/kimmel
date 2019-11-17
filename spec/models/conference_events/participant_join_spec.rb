require "rails_helper"

RSpec.describe ConferenceEvents::ParticipantJoin do
  describe "#apply" do
    it "updates a participants status to :in_progress" do
      call = create(:incoming_call)
      participant = create(:participant, call: call)

      described_class.new(sid: participant.sid, conference_sid: "1234").apply(call)

      expect(participant.reload.status).to eq("in_progress")
    end

    it "sets the conference sid if it does not exist" do
      call = create(:incoming_call, :initiated)
      participant = create(:participant, call: call)

      described_class.new(sid: participant.sid, conference_sid: "1234").apply(call)

      expect(call.conference_sid).to eq("1234")
    end

    it "ensures the conference is set to in progress" do
      call = create(:incoming_call, :initiated)
      participant = create(:participant, call: call)

      described_class.new(sid: participant.sid, conference_sid: "1234").apply(call)

      expect(call.in_state?(:in_progress)).to eq(true)
    end
  end
end

require "rails_helper"

RSpec.describe ToggleMutedForConferenceParticipant, type: :model do
  describe "#call" do
    it "returns success when it updates the conference participant to be muted" do
      call = create(:incoming_call, conference_sid: "fakeConferenceSid")
      participant = create(:participant, call: call, muted: false)

      result = described_class.new(participant, adapter: fake_adapter).call

      participant.reload
      expect(result.success?).to be(true)
      expect(participant.muted?).to be(true)
      expect(fake_adapter).to have_recieved(:update_conference_participant)
    end

    it "returns success when it updates the conference participant to be not muted" do
      call = create(:incoming_call, conference_sid: "fakeConferenceSid")
      participant = create(:participant, call: call, muted: true)

      result = described_class.new(participant, adapter: fake_adapter).call

      participant.reload
      expect(result.success?).to be(true)
      expect(participant.muted?).to be(false)
      expect(fake_adapter).to have_recieved(:update_conference_participant)
    end

    it "returns failure when it fails to update the conference participant" do
      call = create(:incoming_call, conference_sid: "fakeConferenceSid")
      participant = create(:participant, call: call)
      adapter = double(update_conference_participant: false)

      result = described_class.new(participant, adapter: adapter).call

      expect(result.success?).to be(false)
    end
  end

  def fake_adapter
    @fake_adapter = spy(
      update: true
    )
  end
end

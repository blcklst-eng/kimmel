require "rails_helper"

RSpec.describe EndParticipantCall, type: :model do
  describe "#call" do
    it "ends the specified call leg" do
      adapter = spy(end_call: true)
      participant = create(:participant, :in_progress)

      result = described_class.new(participant, adapter: adapter).call

      expect(result.success?).to be(true)
      expect(adapter).to have_received(:end_call).with(participant.sid)
      expect(participant).to be_completed
    end

    it "returns failure if the participant is already completed" do
      participant = create(:participant, :completed)

      result = described_class.new(participant).call

      expect(result.success?).to be(false)
    end
  end
end

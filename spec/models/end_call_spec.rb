require "rails_helper"

RSpec.describe EndCall, type: :model do
  describe "#call" do
    it "ends the conference if the conference is started" do
      adapter = spy(end_conference: true)
      user = create(:user_with_number)
      call = create(:outgoing_call, :in_progress, user: user, sid: "1234")

      result = described_class.new(call, adapter: adapter).call

      expect(result.success?).to be(true)
      expect(adapter).to have_received(:end_conference)
      expect(call.in_state?(:completed)).to be(true)
    end

    it "cancels the active call legs if the conference has not started" do
      adapter = spy(end_conference: false, cancel_call: true)
      user = create(:user_with_number)
      call = create(:outgoing_call, :initiated, user: user, sid: "1234")
      participant = create(:participant, :in_progress, call: call)

      result = described_class.new(call, adapter: adapter).call

      expect(result.success?).to be(true)
      expect(adapter).to have_received(:cancel_call)
      expect(call.in_state?(:canceled)).to be(true)
      expect(participant.reload.status).to eq("completed")
    end

    it "returns failure if the call is not active" do
      user = create(:user_with_number)
      call = create(:outgoing_call, :completed, user: user)

      result = described_class.new(call).call

      expect(result.success?).to be(false)
    end
  end
end

require "rails_helper"

describe MergeCall, type: :model do
  describe "#call" do
    it "moves participants from one call to another" do
      call_from = create(:incoming_call, :initiated)
      participant = create(:participant, call: call_from)
      call_to = create(:incoming_call)
      fake_connector = stub_const(
        "ConnectCallToConference",
        spy(success?: true, connected: [participant.sid], failed: [])
      )

      result = MergeCall.new(to: call_to, from: call_from).call

      expect(result.success?).to be(true)
      expect(call_to.participants.count).to eq(1)
      expect(fake_connector).to have_received(:new).with(
        call: call_to,
        sids: [call_from.participants.first.sid]
      )
      expect(fake_connector).to have_received(:call)
      expect(call_from.completed?).to be(true)
    end

    it "returns failure when it failed to connect a participant" do
      call_from = create(:incoming_call)
      participant = create(:participant, call: call_from)
      call_to = create(:incoming_call)
      fake_connector = stub_const(
        "ConnectCallToConference",
        spy(success?: false, connected: [], failed: [participant.sid])
      )

      result = MergeCall.new(to: call_to, from: call_from).call

      expect(result.success?).to be(false)
      expect(call_to.participants.count).to eq(0)
      expect(fake_connector).to have_received(:new).with(
        call: call_to,
        sids: [call_from.participants.first.sid]
      )
      expect(fake_connector).to have_received(:call)
    end
  end
end

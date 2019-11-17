require "rails_helper"

RSpec.describe ReceiveRingGroupCall do
  describe "#call" do
    it "creates calls and dials in each available member" do
      ring_group = create(:ring_group_with_number)
      create(:ring_group_member, :available, ring_group: ring_group)
      create(:ring_group_member, :available, ring_group: ring_group)
      dialer = stub_const("DialUserIntoIncomingCall", spy(success?: true))

      result = described_class.new(
        to: ring_group.number,
        from: "+18282552500",
        sid: "1234"
      ).call

      expect(result.success?).to be(true)
      call = RingGroupCall.first
      expect(result.response).to include("queue")
      expect(call.ring_group).to eq(ring_group)
      expect(dialer).to have_received(:call).twice
    end

    it "broadcasts a job to manage no answer state" do
      ring_group = create(:ring_group_with_number)
      create(:ring_group_member, :available, ring_group: ring_group)
      stub_const("DialUserIntoIncomingCall", spy(success?: true))

      expect {
        described_class.new(
          to: ring_group.number,
          from: "+18282552500",
          sid: "1234"
        ).call
      }.to have_enqueued_job(RingGroupCallTimeoutJob)
    end

    it "creates a missed ring group call when no members are available" do
      ring_group = create(:ring_group_with_number)
      create(:ring_group_member, :unavailable, ring_group: ring_group)
      dialer = stub_const("DialUserIntoIncomingCall", spy)

      result = described_class.new(
        to: ring_group.number,
        from: "+18282552500",
        sid: "1234"
      ).call

      expect(result.success?).to be(true)
      call = RingGroupCall.first
      expect(call).to be_missed
      expect(result.response).to include("voicemail")
      expect(dialer).not_to have_received(:call)
    end

    it "does not receive a call if the to number does not have a ring group" do
      result = described_class.new(
        to: double(ring_group: nil),
        from: "+18285555000",
        sid: "123456789"
      ).call

      expect(RingGroupCall.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end
end

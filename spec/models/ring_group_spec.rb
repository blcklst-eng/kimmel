require "rails_helper"

RSpec.describe RingGroup, type: :model do
  it_should_behave_like "an assignable"

  describe "#phone_number" do
    it "returns the phone number string for the ring group" do
      number = create(:phone_number)
      ring_group = create(:ring_group, number: number)

      result = ring_group.phone_number

      expect(result).to eq(number.number)
    end

    it "is not valid if the voicemail greeting is not audio", :active_storage do
      ring_group = build(:ring_group, voicemail_greeting: create_blob(content_type: "text/plain"))

      expect(ring_group).not_to be_valid
    end
  end

  describe "#receive_incoming_call" do
    it "passes along the call to a ring group receiver" do
      ring_group = create(:ring_group_with_number)
      receiver = stub_const("ReceiveRingGroupCall", spy(call: Result.success))

      result = ring_group.receive_incoming_call(
        to: ring_group.number,
        from: "+18282552550",
        sid: "1234"
      )

      expect(result.success?).to be(true)
      expect(receiver).to have_received(:new).with(hash_including(to: ring_group.number))
      expect(receiver).to have_received(:call)
    end
  end

  describe "#available?" do
    it "is available if any members are available" do
      ring_group = create(:ring_group)
      create(:ring_group_member, :available, ring_group: ring_group)

      result = ring_group.available?

      expect(result).to be(true)
    end

    it "is not available if no members are available" do
      ring_group = create(:ring_group)
      create(:ring_group_member, :unavailable, ring_group: ring_group)

      result = ring_group.available?

      expect(result).to be(false)
    end
  end

  describe "#member?" do
    it "returns true for a user that is a member" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])

      result = ring_group.member?(user)

      expect(result).to be(true)
    end

    it "returns false for a user that is not a member" do
      user = create(:user)
      ring_group = create(:ring_group)

      result = ring_group.member?(user)

      expect(result).to be(false)
    end
  end

  describe "#last_communication_at" do
    it "returns the time of the last ring group call" do
      ring_group = create(:ring_group)
      ring_group_call = create(:ring_group_call, ring_group: ring_group, created_at: 1.week.ago)

      result = ring_group.last_communication_at

      expect(result.to_i).to eq(ring_group_call.created_at.to_i)
    end

    it "returns nil if the ring group has never had any communication" do
      ring_group = build_stubbed(:ring_group)

      result = ring_group.last_communication_at

      expect(result).to be_nil
    end
  end
end

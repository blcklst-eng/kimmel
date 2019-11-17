require "rails_helper"

RSpec.describe RingGroupCall, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build_stubbed(:ring_group_call)).to be_valid
    end

    it { should validate_presence_of(:from_phone_number) }
    it { should validate_presence_of(:from_sid) }
  end

  describe ".for_ring_group" do
    it "finds calls for a ring group" do
      ring_group = create(:ring_group)
      call = create(:ring_group_call, ring_group: ring_group)

      result = described_class.for_ring_group(ring_group)

      expect(result).to include(call)
    end
  end

  describe ".receive" do
    it "creates a ring group call and associated incoming calls" do
      ring_group = create(:ring_group_with_number)
      create(:ring_group_member, :available, ring_group: ring_group)
      create(:ring_group_member, :available, ring_group: ring_group)

      call = described_class.receive(
        ring_group: ring_group,
        from: "+18282555500",
        sid: "1234"
      )

      expect(call.ring_group).to eq(ring_group)
      expect(call.incoming_calls.count).to eq(2)
      expect(Contact.count).to eq(2)
    end
  end

  describe "#owner?" do
    it "returns true for a user that is a member of the ring group" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      call = create(:ring_group_call, ring_group: ring_group)

      result = call.owner?(user)

      expect(result).to be(true)
    end

    it "returns false for a user that is not a member of the ring group" do
      user = create(:user)
      call = create(:ring_group_call)

      result = call.owner?(user)

      expect(result).to be(false)
    end
  end

  describe "#greeting" do
    it "does not play a greeting" do
      response = Twilio::TwiML::VoiceResponse.new

      result = subject.greeting(response)

      expect(result.to_s).not_to include("</Play>")
    end
  end

  describe "#hangup" do
    it "sets the ring group call to missed and ends all associated incoming calls" do
      ring_group_call = create(:ring_group_call)
      create(:incoming_call, ring_group_call: ring_group_call)
      create(:incoming_call, ring_group_call: ring_group_call)
      end_call = stub_const("EndCall", spy)

      result = ring_group_call.hangup

      expect(result).to be(true)
      expect(end_call).to have_received(:call).twice
      expect(ring_group_call.reload).to be_missed
    end
  end

  describe "#unanswered?" do
    it "returns true if no incoming calls were answered" do
      ring_group_call = create(:ring_group_call)
      create(:incoming_call, :no_answer, ring_group_call: ring_group_call)

      result = ring_group_call.unanswered?

      expect(result).to be(true)
    end

    it "returns false if it has a incoming call that was answered" do
      ring_group_call = create(:ring_group_call)
      create(:incoming_call, :in_progress, ring_group_call: ring_group_call)

      result = ring_group_call.unanswered?

      expect(result).to be(false)
    end
  end
end

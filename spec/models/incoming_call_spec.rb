require "rails_helper"

RSpec.describe IncomingCall, type: :model do
  describe ".receive" do
    it "creates a call and participant" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)

      call = described_class.receive(
        user: user,
        from: contact.phone_number,
        sid: "1234"
      )

      expect(call.user).to eq(user)
      expect(call.contacts).to include(contact)
    end
  end

  describe "#missed?" do
    it "is missed if the status indicates no answser" do
      call = build_stubbed(:incoming_call, :no_answer)

      result = call.missed?

      expect(result).to be(true)
    end
  end

  describe "#router" do
    it "returns the incoming call router if the call did not originate from a ring group" do
      call = build_stubbed(:incoming_call, :in_progress)

      result = call.router

      expect(result).to eq(RouteIncomingCall)
    end

    it "returns the ring group router when the call came from a ring group" do
      ring_group_call = build_stubbed(:ring_group_call)
      call = build_stubbed(:incoming_call, :in_progress, ring_group_call: ring_group_call)

      result = call.router

      expect(result).to eq(RouteRingGroupCall)
    end
  end

  describe "#from_phone_number" do
    it "returns the phone number the call is from" do
      contact = build_stubbed(:contact, phone_number: "+18282552550")
      call = build_stubbed(
        :incoming_call,
        participants: [build_stubbed(:participant, contact: contact)]
      )

      result = call.from_phone_number

      expect(result).to eq("+18282552550")
    end
  end

  describe "#to_phone_number" do
    it "returns the phone number of the user" do
      user = build_stubbed(:user_with_number)
      call = build_stubbed(:incoming_call, user: user)

      result = call.to_phone_number

      expect(result).to eq(user.phone_number)
    end
  end

  describe "#greeting" do
    it "does not play a greeting" do
      response = Twilio::TwiML::VoiceResponse.new

      result = subject.greeting(response)

      expect(result.to_s).not_to include("</Play>")
    end
  end
end

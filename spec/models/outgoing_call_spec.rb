require "rails_helper"

RSpec.describe OutgoingCall, type: :model do
  describe ".make" do
    it "creates a call and participant" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)

      call = described_class.make(
        user: user,
        to: contact.phone_number,
        sid: "1234"
      )

      expect(call.user).to eq(user)
      expect(call.sid).to eq("1234")
      expect(call.contacts).to include(contact)
    end
  end

  describe "#missed?" do
    it "is never missed" do
      call = build_stubbed(:outgoing_call, :no_answer)

      result = call.missed?

      expect(result).to be(false)
    end
  end

  describe "#router" do
    it "returns the correct router" do
      call = build_stubbed(:outgoing_call, :in_progress)

      result = call.router

      expect(result).to eq(RouteOutgoingCall)
    end
  end

  describe "#from_phone_number" do
    it "returns the phone number of the user" do
      user = build_stubbed(:user_with_number)
      call = build_stubbed(:outgoing_call, user: user)

      result = call.from_phone_number

      expect(result).to eq(user.phone_number)
    end
  end

  describe "#to_phone_number" do
    it "returns the phone number of the participant being called" do
      contact = build_stubbed(:contact, phone_number: "+18282552550")
      call = build_stubbed(
        :outgoing_call,
        participants: [build_stubbed(:participant, contact: contact)]
      )

      result = call.to_phone_number

      expect(result).to eq("+18282552550")
    end
  end

  describe "#greeting" do
    it "plays a greeting" do
      response = Twilio::TwiML::VoiceResponse.new

      result = subject.greeting(response)

      expect(result.to_s).to include("</Play>")
    end
  end
end

require "rails_helper"

RSpec.describe ReceiveCall do
  describe "#call" do
    it "creates a call from a new contact" do
      user = create(:user_with_number)
      stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

      result = described_class.new(
        to: user.number,
        from: "+18282519900",
        sid: "1234"
      ).call

      expect(result.success?).to be(true)
      call = IncomingCall.first
      expect(call.user).to eq(user)
      expect(call.participants.first.phone_number).to eq("+18282519900")
      expect(result.response).to include("queue")
    end

    it "creates a call from an existing contact" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

      result = described_class.new(
        to: user.number,
        from: contact.phone_number,
        sid: "1234"
      ).call

      expect(result.success?).to be(true)
      call = IncomingCall.first
      expect(call.user).to eq(user)
      expect(call.contacts).to include(contact)
      expect(result.response).to include("queue")
    end

    it "does not receive a call if the to number does not have a user" do
      result = described_class.new(
        to: double(user: nil),
        from: "+18285555000",
        sid: "123456789"
      ).call

      expect(IncomingCall.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end

    it "does not receive a call if it cannot connect to the user" do
      user = create(:user_with_number)
      stub_const("ConnectCall", spy(call: Result.failure("fail")))

      result = described_class.new(
        to: user.number,
        from: "+18285555000",
        sid: "123456789"
      ).call

      call = IncomingCall.first
      expect(call.in_state?(:failed)).to be(true)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end

    it "does not connect user that is not available" do
      user = create(:user_with_number, available: false)
      fake_connector = spy
      stub_const("ConnectCall", fake_connector)

      described_class.new(
        to: user.number,
        from: "+18285555000",
        sid: "123456789"
      ).call

      call = IncomingCall.first
      expect(call.in_state?(:no_answer)).to be(true)
      expect(fake_connector).not_to have_received(:call)
    end

    it "returns a voicemail response when a user is not available" do
      user = create(:user_with_number, available: false)

      result = described_class.new(
        to: user.number,
        from: "+18285555000",
        sid: "123456789"
      ).call

      expect(result.response).to include("voicemail")
    end
  end
end

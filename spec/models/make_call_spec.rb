require "rails_helper"

RSpec.describe MakeCall do
  describe "#call" do
    it "creates a call from a new contact" do
      phone_number = create(:phone_number, number: "+15005550006")
      user = create(:user, number: phone_number)
      stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

      result = described_class.new(
        from: user.client,
        to: "+18282519900",
        sid: "123456789",
        adapter: double(lookup: LookupResult.new(phone_number: "+18282519900"))
      ).call

      expect(result.success?).to be(true)
      call = OutgoingCall.first
      expect(call.user).to eq(user)
      expect(call.participants.first.phone_number).to eq("+18282519900")
      expect(result.response).to include("queue")
    end

    it "creates a call from an existing contact" do
      phone_number = create(:phone_number, number: "+15005550006")
      user = create(:user, number: phone_number)
      contact = create(:contact, user: user)
      stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

      result = described_class.new(
        from: user.client,
        to: contact.phone_number,
        sid: "123456789",
        adapter: double(lookup: LookupResult.new(phone_number: contact.phone_number))
      ).call

      expect(result.success?).to be(true)
      call = OutgoingCall.first
      expect(call.user).to eq(user)
      expect(call.contacts).to include(contact)
      expect(result.response).to include("queue")
    end

    it "returns an invalid phone number response if the phone number is invalid" do
      user = create(:user)

      result = described_class.new(
        from: user.client,
        to: "+15005550001",
        sid: "123456789",
        adapter: double(lookup: LookupResult.new(phone_number: nil))
      ).call

      expect(OutgoingCall.count).to eq(0)
      expect(result.success?).to be(true)
      expect(result.response).to include("Say")
    end

    it "does not receive a call if the from is invalid" do
      result = described_class.new(
        from: "client:123",
        to: "+18285555000",
        sid: "123456789",
        adapter: double(lookup: LookupResult.new(phone_number: "18285555000"))
      ).call

      expect(OutgoingCall.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end
end

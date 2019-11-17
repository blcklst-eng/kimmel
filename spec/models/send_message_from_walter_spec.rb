require "rails_helper"

RSpec.describe SendMessageFromWalter, type: :model do
  describe "#call" do
    it "returns invalid phone number if the phone number is invalid" do
      fake_adapter = spy(TwilioAdapter, lookup: LookupResult.new(phone_number: nil))
      user = create(:user)

      params = {
        contact_args: {
          first_name: "Contact First Name",
          last_name: "Contact Last Name",
          phone_number: "555",
          walter_id: 123,
        },
        body: "Text Message Body",
        user_walter_id: user.walter_id,
      }

      result = described_class.new(**params, adapter: fake_adapter).call

      expect(result.success?).to be(false)
      expect(result.errors).to include("Invalid phone number")
    end

    it "returns invalid user walter id if the user is not found" do
      params = {
        contact_args: {
          first_name: "Contact First Name",
          last_name: "Contact Last Name",
          phone_number: "8284578683",
          walter_id: 123,
        },
        body: "Text Message Body",
        user_walter_id: 123,
      }

      result = described_class.new(params).call

      expect(result.success?).to be(false)
      expect(result.errors).to include("Invalid User Walter ID")
    end

    it "returns success with valid params" do
      user = create(:user_with_number)

      params = {
        contact_args: {
          first_name: "Contact First Name",
          last_name: "Contact Last Name",
          phone_number: "8284578683",
          walter_id: 123,
        },
        body: "Text Message Body",
        user_walter_id: user.walter_id,
      }

      result = described_class.new(**params, adapter: fake_adapter).call

      expect(result.success?).to be(true)
      expect(Contact.count).to be(1)
      contact = Contact.first
      expect(contact.saved?).to be(true)
      expect(contact.phone_number).to eq("+18284578683")
      expect(contact.first_name).to eq("Contact First Name")
      expect(contact.last_name).to eq("Contact Last Name")
    end
  end

  def fake_adapter
    spy(
      lookup: LookupResult.new(phone_number: "+18284578683"),
      send_message: SendMessageResult.new(sent?: true)
    )
  end
end

require "rails_helper"

RSpec.describe CreateContact do
  describe "#call" do
    it "creates a contact if the number is valid" do
      params = {
        user: create(:user),
        first_name: "John",
        last_name: "Doe",
        phone_number: LookupResult.new(phone_number: "+18282519900"),
      }

      result = described_class.new(params).call

      expect(Contact.count).to eq(1)
      expect(result.success?).to be(true)
      expect(result.contact.phone_number).to eq("+18282519900")
      expect(result.contact.saved).to eq(true)
    end

    it "does not create a contact if the provided number is not valid" do
      params = {
        user: create(:user),
        first_name: "John",
        last_name: "Doe",
        phone_number: double(valid?: false),
      }

      result = described_class.new(params).call

      expect(Contact.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end

    it "updates a existing contact for a user" do
      user = create(:user)
      create(:contact, user: user, first_name: "Sam", phone_number: "+18282519900")
      params = {
        user: user,
        first_name: "John",
        phone_number: LookupResult.new(phone_number: "+18282519900"),
      }

      result = described_class.new(params).call

      expect(Contact.count).to eq(1)
      expect(result.success?).to be(true)
      expect(result.contact.first_name).to eq("John")
      expect(result.contact.phone_number).to eq("+18282519900")
    end
  end
end

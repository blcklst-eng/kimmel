require "rails_helper"

RSpec.describe UpdateContact do
  describe "#call" do
    it "updates a contact if the number is not provided" do
      contact = create(:contact)
      params = {
        first_name: "John",
      }

      result = described_class.new(contact: contact, params: params).call

      expect(result.success?).to be(true)
      expect(result.contact.first_name).to eq("John")
    end

    it "updates a contact if the number is valid" do
      contact = create(:contact)
      params = {
        phone_number: LookupResult.new(phone_number: "+18282519900"),
      }

      result = described_class.new(contact: contact, params: params).call

      expect(result.success?).to be(true)
      expect(result.contact.phone_number).to eq("+18282519900")
    end

    it "marks an unsaved contact as saved" do
      contact = create(:contact, :unsaved)
      params = {
        first_name: "John",
      }

      result = described_class.new(contact: contact, params: params).call

      expect(result.success?).to be(true)
      expect(result.contact.saved).to eq(true)
    end

    it "does not update a contact if the provided number is not valid" do
      contact = create(:contact)
      params = {
        phone_number: double(valid?: false),
      }

      result = described_class.new(contact: contact, params: params).call

      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end
end

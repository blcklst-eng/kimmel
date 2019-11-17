require "rails_helper"

RSpec.describe LookupResult do
  describe "#valid?" do
    it "is valid if it has a phone number" do
      result = described_class.new(phone_number: "+18282519900")

      expect(result).to be_valid
    end

    it "is not valid without a phone number" do
      result = described_class.new(phone_number: nil)

      expect(result).not_to be_valid
    end
  end

  describe "#to_s" do
    it "returns the phone number as a string" do
      result = described_class.new(phone_number: "+18282519900")

      expect(result.to_s).to eq("+18282519900")
    end
  end
end

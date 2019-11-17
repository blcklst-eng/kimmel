require "rails_helper"

RSpec.describe UnrecordablePhoneNumber, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:unrecordable_phone_number)).to be_valid
    end

    it { should validate_presence_of(:number) }

    it "is not valid with non-unique phone number" do
      create(:unrecordable_phone_number, number: "+11231231234")
      phone_number = build(:unrecordable_phone_number, number: "+11231231234")

      expect(phone_number).not_to be_valid
    end
  end

  describe ".recordable?" do
    it "returns true for a number that is not unrecordable" do
      result = UnrecordablePhoneNumber.recordable?("+18282552550")

      expect(result).to be(true)
    end

    it "returns false for a number that is unrecordable" do
      create(:unrecordable_phone_number, number: "+18282552550")

      result = UnrecordablePhoneNumber.recordable?("+18282552550")

      expect(result).to be(false)
    end

    it "returns false if any numbers provided are unrecordable" do
      create(:unrecordable_phone_number, number: "+18282552550")

      result = UnrecordablePhoneNumber.recordable?(["+18282552550", "+18285555500"])

      expect(result).to be(false)
    end
  end
end

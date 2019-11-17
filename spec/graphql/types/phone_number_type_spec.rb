require "rails_helper"

describe Types::PhoneNumberType do
  describe ".coerce_input" do
    it "converts a string to a LookupResult" do
      stub_const("TwilioAdapter", spy(lookup: LookupResult.new))
      lookup_result = described_class.coerce_input("(828)251-9900", {})

      expect(lookup_result).to be_a(LookupResult)
    end
  end
end

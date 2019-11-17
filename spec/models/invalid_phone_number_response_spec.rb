require "rails_helper"

RSpec.describe InvalidPhoneNumberResponse do
  describe "#to_s" do
    it "generates xml that contains a message" do
      result = described_class.new.to_s

      expect(result).to include("</Say>")
    end
  end
end

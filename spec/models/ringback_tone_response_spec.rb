require "rails_helper"

RSpec.describe RingbackToneResponse do
  describe "#to_s" do
    it "generates xml that contains our ringback tone" do
      stub_const("AssetHelper", double(url: "https://google.com/test.wav"))
      result = described_class.new.to_s

      expect(result).to include("<Play>https://google.com/test.wav</Play>")
    end
  end
end

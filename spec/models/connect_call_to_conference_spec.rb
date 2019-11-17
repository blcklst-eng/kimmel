require "rails_helper"

RSpec.describe ConnectCallToConference do
  describe "#call" do
    it "connects the sids to a conference call" do
      call = double
      adapter = spy(update_call: true)

      result = described_class.new(
        call: call,
        sids: ["1234"],
        adapter: adapter
      ).call

      expect(result.success?).to be(true)
      expect(result.connected).to include("1234")
      expect(result.failed).to be_empty
    end

    it "returns a failure if the connection fails" do
      call = double
      adapter = spy(update_call: false)

      result = described_class.new(
        call: call,
        sids: ["1234"],
        adapter: adapter
      ).call

      expect(result.success?).to be(false)
      expect(result.connected).to be_empty
      expect(result.failed).to include("1234")
    end
  end
end

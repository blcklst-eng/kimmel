require "rails_helper"

RSpec.describe DialIntoConferenceResponse do
  describe "#to_s" do
    it "generates xml that dials the call into a conference" do
      call = build_stubbed(:incoming_call)

      result = described_class.new(call).to_s

      expect(result).to include("record-from-start")
      expect(result).to include("#{call.id}</Conference>")
    end
  end
end

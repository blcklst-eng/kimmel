require "rails_helper"

RSpec.describe QueueCallResponse do
  describe "#to_s" do
    it "generates xml that queues the call" do
      call = build_stubbed(:outgoing_call)

      result = described_class.new(call: call).to_s

      expect(result).to include("</Enqueue>")
      expect(result).to include(RouteHelper.queue_call_url(call))
    end
  end
end

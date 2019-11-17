require "rails_helper"

RSpec.describe ConferenceEvents::ConferenceStart do
  describe "#apply" do
    let(:params) { {conference_sid: "FAKESID"} }

    it "updates a calls status to :in_progress" do
      call = create(:incoming_call, :initiated)
      described_class.new(params).apply(call)

      expect(call.in_state?(:in_progress)).to be(true)
    end

    it "updates a calls conference sid" do
      call = create(:incoming_call)
      described_class.new(params).apply(call)

      expect(call.reload.conference_sid).to eq("FAKESID")
    end
  end
end

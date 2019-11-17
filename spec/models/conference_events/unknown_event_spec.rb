require "rails_helper"

RSpec.describe ConferenceEvents::UnknownEvent do
  describe "#apply" do
    it "does nothing" do
      call = create(:incoming_call)
      participant = create(:participant, call: call, status: :initiated)

      described_class.new.apply(call)

      expect(participant.reload.status).to eq("initiated")
    end
  end
end

require "rails_helper"

RSpec.describe ConferenceEvents::ConferenceEnd do
  describe "#apply" do
    it "updates a call and participants to completed" do
      stub_const("TwilioAdapter", spy(end_conference: true))
      call = create(:incoming_call, :in_progress)
      participant = create(:participant, call: call, status: :in_progress)

      described_class.new.apply(call)

      expect(call.in_state?(:completed)).to be(true)
      expect(participant.reload).to be_completed
    end

    it "does not change the status if the call is already in a completed state" do
      call = create(:incoming_call, :no_answer)

      described_class.new.apply(call)

      expect(call.in_state?(:no_answer)).to be(true)
    end
  end
end

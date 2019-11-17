require "rails_helper"

RSpec.describe "Call Status API", :as_twilio, type: :request do
  describe "POST #store" do
    context "with valid params" do
      it "updates the participant status when they join" do
        call = create(:incoming_call, :in_progress)
        participant = create(:participant, call: call, status: :initiated)

        post call_status_url, params: {
          FriendlyName: call.id.to_s,
          StatusCallbackEvent: "participant-join",
          CallSid: participant.sid,
          ConferenceSid: "1234",
        }

        expect(participant.reload.status).to eq("in_progress")
      end

      it "updates the participant status when they leave" do
        call = create(:incoming_call, :in_progress)
        participant = create(:participant, call: call, status: :in_progress)
        create(:participant, call: call, status: :in_progress)

        post call_status_url, params: {
          FriendlyName: call.id.to_s,
          StatusCallbackEvent: "participant-leave",
          CallSid: participant.sid,
        }

        expect(participant.reload.status).to eq("completed")
      end

      it "updates the call status when the conference is over" do
        stub_const("TwilioAdapter", spy(end_conference: true))
        call = create(:incoming_call, :in_progress)

        post call_status_url, params: {
          FriendlyName: call.id.to_s,
          StatusCallbackEvent: "conference-end",
        }

        expect(call.reload.in_state?(:completed)).to be(true)
      end

      it "updates the call status when the conference has started" do
        call = create(:incoming_call, :initiated)

        post call_status_url, params: {
          FriendlyName: call.id.to_s,
          StatusCallbackEvent: "conference-start",
        }

        expect(call.reload.in_state?(:in_progress)).to be(true)
      end
    end
  end
end

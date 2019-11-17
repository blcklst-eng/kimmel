require "rails_helper"

RSpec.describe "Queue Call API", :as_twilio, type: :request do
  describe "#store" do
    it "ends a conference if the call hangs up" do
      call = create(:incoming_call)
      end_call = stub_const("EndCall", spy)

      post queue_call_url(call), params: {
        CallSid: call.sid,
        QueueResult: "hangup",
      }

      expect(response).to have_http_status(:ok)
      expect(end_call).to have_received(:call)
    end

    it "ends all calls associated with the ring group call if the call hangs up" do
      ring_group_call = create(:ring_group_call)
      create(:incoming_call, ring_group_call: ring_group_call)
      create(:incoming_call, ring_group_call: ring_group_call)
      end_call = stub_const("EndCall", spy)

      post queue_call_url(ring_group_call), params: {
        CallSid: ring_group_call.from_sid,
        QueueResult: "hangup",
      }

      expect(response).to have_http_status(:ok)
      expect(end_call).to have_received(:call).twice
      expect(ring_group_call.reload).to be_missed
    end

    it "does nothing if the incoming call did not hang up" do
      call = create(:incoming_call)
      end_call = stub_const("EndCall", spy)

      post queue_call_url(call), params: {
        CallSid: call.sid,
        QueueResult: "something-else",
      }

      expect(response).to have_http_status(:ok)
      expect(end_call).not_to have_received(:call)
    end
  end
end

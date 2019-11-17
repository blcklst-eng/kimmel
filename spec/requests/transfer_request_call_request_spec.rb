require "rails_helper"

describe "Transfer Request Call", :as_twilio, type: :request do
  describe "#store" do
    context "with valid params" do
      it "receives a call and associates it with a transfer request" do
        user = create(:user_with_number)
        contact = create(:contact, user: user, phone_number: "+18285555000")
        stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))
        transfer_request = create(:transfer_request, receiver: user)

        post transfer_request_call_url(transfer_request.id), params: {
          To: user.phone_number,
          From: contact.phone_number,
          CallSid: "1234",
        }

        call = IncomingCall.where.not(id: transfer_request.incoming_call.id).first

        expect(call).not_to be(nil)
        expect(call.user).to eq(user)
        expect(call.transfer_request).to eq(transfer_request)
        expect(call.contacts).to include(contact)
        expect(response).to have_http_status(:created)
        expect(response.body).to include("Enqueue")
      end
    end
  end
end

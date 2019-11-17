require "rails_helper"

RSpec.describe "Transfer Participant API", :as_twilio, type: :request do
  describe "POST #create" do
    context "with valid params" do
      it "creates an incoming call" do
        user = create(:user_with_number)
        contact = create(:contact, user: user, phone_number: "+18285555000")
        stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

        post transfer_participant_url(
          to: user.phone_number,
          from: contact.phone_number
        ), params: {
          CallSid: "1234",
        }

        call = IncomingCall.first
        expect(call.user).to eq(user)
        expect(call.contacts).to include(contact)
        expect(response).to have_http_status(:created)
        expect(response.body).to include("Enqueue")
      end
    end
  end
end

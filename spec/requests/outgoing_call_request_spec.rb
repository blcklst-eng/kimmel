require "rails_helper"

RSpec.describe "Outgoing Call API", :as_twilio, type: :request do
  describe "POST #create" do
    context "with valid params" do
      it "creates an outgoing call" do
        stub_const("TwilioAdapter", spy(lookup: LookupResult.new(phone_number: "+18285555000")))
        user = create(:user_with_number)
        contact = create(:contact, user: user, phone_number: "+18285555000")

        post outgoing_call_url, params: {
          To: contact.phone_number,
          From: user.client,
          CallSid: "1234abcdef",
        }

        call = OutgoingCall.first
        expect(call.user).to eq(user)
        expect(call.sid).to eq("1234abcdef")
        expect(call.contacts).to include(contact)
        expect(response).to have_http_status(:created)
        expect(response.body).to include("Enqueue")
      end
    end
  end
end

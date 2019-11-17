require "rails_helper"

RSpec.describe "Incoming Call API", :as_twilio, type: :request do
  describe "POST #create" do
    context "with valid params" do
      it "creates an incoming call" do
        user = create(:user_with_number)
        contact = create(:contact, user: user, phone_number: "+18285555000")
        stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

        post incoming_call_url, params: {
          To: user.phone_number,
          From: contact.phone_number,
          CallSid: "1234",
        }

        call = IncomingCall.first
        expect(call.user).to eq(user)
        expect(call.contacts).to include(contact)
        expect(response).to have_http_status(:created)
        expect(response.body).to include("Enqueue")
      end

      it "recieves a call for a ring group" do
        user = create(:user_with_number)
        ring_group = create(:ring_group_with_number)
        create(:ring_group_member, :available, user: user, ring_group: ring_group)
        stub_const("ConnectCall", spy(call: Result.success(sid: "1234")))

        post incoming_call_url, params: {
          To: ring_group.phone_number,
          From: "+18285555000",
          CallSid: "1234",
        }

        call = RingGroupCall.first
        expect(call.ring_group).to eq(ring_group)
        expect(call.incoming_calls.count).to eq(1)
        expect(response).to have_http_status(:created)
        expect(response.body).to include("Enqueue")
      end
    end
  end
end

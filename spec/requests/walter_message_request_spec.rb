require "rails_helper"

RSpec.describe "Walter Message API", :as_twilio, type: :request do
  describe "#store" do
    it "returns 200 status when the message is sent" do
      stub_const("TwilioAdapter", fake_adapter)
      user = create(:user_with_number, walter_id: 1)

      post walter_message_url, params: {
        token: walter_token,
        first_name: "Contact First Name",
        last_name: "Contact Last Name",
        contact_walter_id: 555,
        to: "8284578683",
        body: "Testing a message from walter.",
        user_walter_id: user.walter_id,
      }

      expect(response).to have_http_status(:created)
    end

    it "returns unauthorized when a invalid token is provided" do
      stub_const("TwilioAdapter", fake_adapter)
      user = create(:user, walter_id: 1)

      post walter_message_url, params: {
        first_name: "Contact First Name",
        last_name: "Contact Last Name",
        contact_walter_id: 555,
        to: "8284578683",
        body: "Testing a message from walter.",
        user_walter_id: user.walter_id,
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  def walter_token
    Rails.application.credentials[:walter_token]
  end

  def fake_adapter
    spy(
      lookup: LookupResult.new(phone_number: "+18284578683"),
      send_message: SendMessageResult.new(sent?: true)
    )
  end
end

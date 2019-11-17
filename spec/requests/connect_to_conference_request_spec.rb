require "rails_helper"

RSpec.describe "Connect To Conference API", :as_twilio, type: :request do
  describe "#store" do
    it "generates xml that connects to a conference" do
      participant = create(:participant, sid: "1234")

      post connect_to_conference_url(participant.call), params: {
        CallSid: "1234",
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(
        "#{participant.call_id}</Conference>"
      )
    end
  end
end

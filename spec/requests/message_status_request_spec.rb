require "rails_helper"

RSpec.describe "Message Status API", :as_twilio, type: :request do
  describe "POST #create" do
    context "with valid params" do
      it "updates the status of a message" do
        message = create(:outgoing_message)

        post message_status_url(message), params: {
          MessageStatus: "delivered",
        }

        expect(message.reload.status).to eq("delivered")
      end
    end
  end
end

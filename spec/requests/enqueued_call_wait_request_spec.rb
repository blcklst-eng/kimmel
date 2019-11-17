require "rails_helper"

RSpec.describe "Enqueued Call Wait API", :as_twilio, type: :request do
  describe "#get" do
    it "returns a ringback tone" do
      get enqueued_call_wait_url

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("</Play>")
    end
  end
end

require "rails_helper"

describe "A Invalid Twilio Request", type: :request do
  it "returns a bad request when no signature is present" do
    post incoming_call_url

    expect(response).to have_http_status(:bad_request)
  end

  it "returns unauthorized when the twilio request is not valid" do
    post incoming_call_url, headers: {
      'X-Twilio-Signature': "invalidTwilioSignature",
    }

    expect(response).to have_http_status(:unauthorized)
  end
end

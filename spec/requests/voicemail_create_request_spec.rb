require "rails_helper"

RSpec.describe "Voicemail Create API", :as_twilio, type: :request do
  describe "#create" do
    it "triggers a recording for the voicemail" do
      call = create(:incoming_call)

      get voicemail_create_url(call), params: {CallSid: call.sid}

      expect(response).to have_http_status(:created)
      expect(response.body).to include(
        "<Record action=\"#{voicemail_store_url(call)}\" playBeep=\"true\"/>"
      )
    end

    it "triggers a recording for a ring group voicemail" do
      call = create(:ring_group_call)

      get voicemail_create_url(call), params: {CallSid: call.from_sid}

      expect(response).to have_http_status(:created)
      expect(response.body).to include(
        "<Record action=\"#{voicemail_store_url(call)}\" playBeep=\"true\"/>"
      )
    end
  end
end

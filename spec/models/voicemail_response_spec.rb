require "rails_helper"

RSpec.describe VoicemailResponse do
  describe "#to_s" do
    it "generates xml that links to the voicemail store endpoint for a call" do
      call = create(:incoming_call)
      result = described_class.new(call).to_s

      expect(result).to include(
        "<Record action=\"#{RouteHelper.voicemail_store_url(call)}\" playBeep=\"true\"/>"
      )
    end

    it "has a standard voicemail greeting if the user does not have one set" do
      call = create(:incoming_call)
      result = described_class.new(call).to_s

      expect(result).to include("Please leave a message after the tone")
    end

    it "can play a custom voicemail greeting", :active_storage do
      user = create(:user, voicemail_greeting: create_audio_blob)
      call = create(:incoming_call, user: user)
      result = described_class.new(call).to_s

      expect(result).to include(
        "<Play>#{RouteHelper.rails_blob_url(user.voicemail_greeting)}</Play"
      )
    end
  end
end

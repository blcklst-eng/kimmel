require "rails_helper"

RSpec.describe StatsCallNotificationJob, type: :job do
  describe "#perform" do
    it "sends a request with the call data to stats endpoint" do
      fake_endpoint = set_fake_endpoint
      fake_http = stub_const("HTTP", spy(HTTP))
      user = create(:user, intranet_id: 1)
      call = create(:outgoing_call, user: user, duration: 20)
      contact = create(:contact, phone_number: "+18282555500", user: user)
      create(:participant, call: call, contact: contact)

      described_class.perform_now(call)

      expect(fake_http).to have_received(:post).with(fake_endpoint, params: {
        intranet_id: 1,
        contact_number: "+18282555500",
        is_outgoing: true,
        duration: 20,
      })
    end

    it "does not send a request when no endpoint is set" do
      Rails.application.config.stats_notification_endpoint = nil
      fake_http = stub_const("HTTP", spy)
      call = create(:outgoing_call)

      described_class.perform_now call

      expect(fake_http).not_to have_received(:post)
    end
  end

  def set_fake_endpoint
    Rails.application.config.stats_notification_endpoint = "http://stats.com"
  end
end

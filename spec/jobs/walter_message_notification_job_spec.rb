require "rails_helper"

RSpec.describe WalterMessageNotificationJob, type: :job do
  describe "#perform" do
    it "does not send a request when no endpoint is set" do
      fake_http = spy(HTTP)
      message = create(:outgoing_message)

      expect(fake_http).not_to receive(:post)

      stub_const("HTTP", fake_http)

      described_class.perform_now message
    end

    it "sends a request with the outgoing message info to walter endpoint" do
      fake_http = spy(HTTP)
      message = create(:outgoing_message)

      expect(fake_http).to receive(:post).with(walter_endpoint, params:
        {
          contact_walter_id: message.contact.walter_id,
          first_name: message.contact.first_name,
          last_name: message.contact.last_name,
          to: message.to,
          body: message.body,
          user_walter_id: message.user.walter_id,
          type: message.type,
        })

      stub_const("HTTP", fake_http)

      described_class.perform_now message
    end
  end

  def walter_endpoint
    Rails.application.config.walter_notification_endpoint = "http://fakewalterendpoint.com"
  end
end

require "rails_helper"

RSpec.describe TwilioNotification do
  context "#payload" do
    it "includes apn when badge is present" do
      result = TwilioNotification.new(
        twilio_notification_args.merge(badge: 10)
      ).payload

      expect(result).to include(
        apn: {
          aps: {
            alert: {
              title: "Some Title",
              body: "Some body text.",
            },
            badge: 10,
          },
        }
      )
    end
  end

  def twilio_notification_args
    {
      to: "1",
      title: "Some Title",
      body: "Some body text.",
    }
  end
end

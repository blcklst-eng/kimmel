require "rails_helper"

RSpec.describe TwilioNotifyAdapter, external_api: true do
  before(:all) do
    Twilio.configure do |config|
      config.account_sid = Rails.application.credentials.dig(:production, :twilio, :account_sid)
      config.auth_token = Rails.application.credentials.dig(:production, :twilio, :auth_token)
    end
  end

  describe "#register_device" do
    it "registers a device" do
      result = subject.register_device(identity: "test-user", type: "apn", address: "1A2F3C")

      expect(result.identity).to eq("test-user")
      expect(result.binding_type).to eq("apn")
      expect(result.address).to eq("1A2F3C")
    end

    it "fails to register a bad device" do
      result = subject.register_device(identity: "test-user", type: "apn", address: "not-valid")

      expect(result).to be(false)
    end
  end

  describe "#send" do
    it "sends a push notification" do
      notification = subject.send(to: 123, title: "hello", body: "body")
      expect(notification.title).to eq("hello")
      expect(notification.body).to eq("body")
    end
  end

  after(:all) do
    Twilio.configure do |config|
      config.account_sid = Rails.application.credentials.dig(:test, :twilio, :account_sid)
      config.auth_token = Rails.application.credentials.dig(:test, :twilio, :auth_token)
    end
  end
end

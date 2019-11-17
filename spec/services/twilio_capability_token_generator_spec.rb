require "rails_helper"

RSpec.describe TwilioCapabilityTokenGenerator do
  describe "#call" do
    it "creates a token" do
      token = described_class.new("test-identifier").call
      decoded_token = decode_token(token)
      incoming_token, outgoing_token = decoded_token.split

      expect(incoming_token).to include("test-identifier")
      expect(outgoing_token).to include("test-identifier")
    end
  end

  def decode_token(token)
    JWT.decode(token, token_secret).first["scope"]
  end

  def token_secret
    Rails.application.credentials.dig(Rails.env.to_sym, :twilio, :auth_token)
  end
end

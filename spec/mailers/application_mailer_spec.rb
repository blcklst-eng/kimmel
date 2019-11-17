require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  describe ".link_to_frontend" do
    it "constructs a link to the frontend" do
      Rails.configuration.frontend_host = "test-host.com"

      link = described_class.new.link_to_frontend(text: "click here", url: "testing")

      expect(link).to eq('<a href="https://test-host.com/testing">click here</a>')
    end
  end
end

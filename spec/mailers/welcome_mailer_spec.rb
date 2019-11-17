require "rails_helper"

RSpec.describe WelcomeMailer, type: :mailer do
  describe ".welcome_email" do
    it "builds the mail" do
      user = create(:user_with_number)

      mail = described_class.welcome_email(user: user)

      expect(mail.subject).to eq("Welcome To Kimmel Nexus!")
      expect(mail.to).to include(user.email)
      expect(mail.body.encoded).to include("Welcome to Kimmel Nexus!")
      expect(mail.body.encoded).to include(user.phone_number)
    end
  end
end

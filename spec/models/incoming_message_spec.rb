require "rails_helper"

RSpec.describe IncomingMessage, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  context "callbacks" do
    describe "after_commit" do
      it "updates the last_contact_at timestamp on the associated contact" do
        freeze_time do
          contact = create(:contact, last_contact_at: 1.week.ago)
          conversation = create(:conversation, contact: contact)
          create(:incoming_message, conversation: conversation)

          expect(contact.last_contact_at).to eq(Time.current)
        end
      end

      it "creates a job to send a notification about the message" do
        user = create(:user)
        conversation = create(:conversation, user: user)

        expect {
          create(:incoming_message, conversation: conversation)
        }.to have_enqueued_job(PublishPushNotificationForMessageJob)
      end
    end
  end

  describe "#to" do
    it "gets the users phone number" do
      user = build_stubbed(:user_with_number)
      conversation = build_stubbed(:conversation, user: user)
      message = build_stubbed(:incoming_message, conversation: conversation)

      phone_number = message.to

      expect(phone_number).to eq(user.phone_number)
    end
  end

  describe "#from" do
    it "gets the contacts phone number" do
      contact = build_stubbed(:contact)
      conversation = build_stubbed(:conversation, contact: contact)
      message = build_stubbed(:incoming_message, conversation: conversation)

      phone_number = message.from

      expect(phone_number).to eq(contact.phone_number)
    end
  end
end

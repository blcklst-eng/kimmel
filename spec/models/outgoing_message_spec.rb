require "rails_helper"

RSpec.describe OutgoingMessage, type: :model do
  context "validations" do
    it { should validate_presence_of(:body) }
  end

  describe "#to" do
    it "gets the contacts phone number" do
      contact = build_stubbed(:contact)
      conversation = build_stubbed(:conversation, contact: contact)
      message = build_stubbed(:outgoing_message, conversation: conversation)

      phone_number = message.to

      expect(phone_number).to eq(contact.phone_number)
    end
  end

  describe "#from" do
    it "gets the users phone number" do
      user = build_stubbed(:user_with_number)
      conversation = build_stubbed(:conversation, user: user)
      message = build_stubbed(:outgoing_message, conversation: conversation)

      phone_number = message.from

      expect(phone_number).to eq(user.phone_number)
    end
  end

  describe "#update_status" do
    it "sets the message status to delivered" do
      message = build(:outgoing_message, status: :sent)

      message.update_status(double(delivered?: true, failed?: false))

      expect(message.status).to eq("delivered")
    end

    it "sets the message status to failed" do
      message = build(:outgoing_message, status: :sent)

      message.update_status(double(delivered?: false, failed?: true))

      expect(message.status).to eq("failed")
    end

    it "broadcasts that a message status has changed" do
      message = build(:outgoing_message, status: :sent)

      expect { message.update_status(double(delivered?: true, failed?: false)) }
        .to have_enqueued_job(BroadcastMessageStatusChangedJob)
    end
  end
end

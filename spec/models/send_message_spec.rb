require "rails_helper"

RSpec.describe SendMessage do
  describe "#call" do
    it "sends a message to a new contact" do
      result = described_class.new(
        to: LookupResult.new(phone_number: "+18282519900"),
        from: create(:user_with_number),
        body: "Test message",
        messenger: double(send_message: SendMessageResult.new(sent?: true))
      ).call

      expect(Contact.count).to eq(1)
      expect(Conversation.count).to eq(1)
      expect(result.success?).to be(true)
      expect(result.conversation.messages.count).to eq(1)
    end

    it "sends a message to an existing conversation" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      conversation = create(:conversation, user: user, contact: contact)

      result = described_class.new(
        to: LookupResult.new(phone_number: contact.phone_number),
        from: user,
        body: "Test message",
        messenger: double(send_message: SendMessageResult.new(sent?: true))
      ).call

      expect(Contact.count).to eq(1)
      expect(Conversation.count).to eq(1)
      expect(result.success?).to be(true)
      expect(conversation.messages.count).to eq(1)
    end

    it "sends a message with attached media", :active_storage do
      media = create_blob
      messenger = spy(send_message: SendMessageResult.new(sent?: true))

      result = described_class.new(
        to: LookupResult.new(phone_number: "+18282519900"),
        from: create(:user_with_number),
        body: "Test message",
        media: media.signed_id,
        messenger: messenger
      ).call

      expect(result.success?).to be(true)
      message = OutgoingMessage.first
      expect(message.media.count).to eq(1)
      expect(messenger).to have_received(:send_message).with(
        hash_including(media_url: [RouteHelper.rails_blob_url(media)])
      )
    end

    it "does not send a message if the number is invalid" do
      result = described_class.new(
        to: double(valid?: false),
        from: create(:user),
        body: "Test message"
      ).call

      expect(Contact.count).to eq(0)
      expect(Conversation.count).to eq(0)
      expect(Message.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end

    it "does not send a message if the body is empty" do
      result = described_class.new(
        to: LookupResult.new(phone_number: "+18282519900"),
        from: create(:user),
        body: "",
        messenger: double(send_message: SendMessageResult.new(sent?: true))
      ).call

      expect(Contact.count).to eq(0)
      expect(Conversation.count).to eq(0)
      expect(Message.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end

    it "does not create a message if a messenger error occurs" do
      result = described_class.new(
        to: LookupResult.new(phone_number: "+18282519900"),
        from: create(:user_with_number),
        body: "Test message",
        messenger: double(send_message: SendMessageResult.new(sent?: false, error: "error"))
      ).call

      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end
end

require "rails_helper"

RSpec.describe ReceiveMessage do
  describe "#call" do
    it "adds a message from a new contact" do
      user = create(:user_with_number)

      result = described_class.new(
        to: user.phone_number,
        from: "+18282519900",
        body: "Test message"
      ).call

      expect(result.success?).to be(true)
      expect(Contact.first.phone_number).to eq("+18282519900")
      expect(Conversation.first.messages.count).to eq(1)
      expect(Message.first.body).to eq("Test message")
    end

    it "adds a message to an existing conversation" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      conversation = create(:conversation, :read, user: user, contact: contact)

      result = described_class.new(
        to: user.phone_number,
        from: contact.phone_number,
        body: "Test message"
      ).call

      expect(result.success?).to be(true)
      expect(Contact.count).to eq(1)
      expect(Conversation.count).to eq(1)
      expect(conversation.messages.count).to eq(1)
      expect(conversation.reload.read).to be(false)
      expect(Message.first.body).to eq("Test message")
    end

    it "adds a message with media" do
      use_fake_downloader
      user = create(:user_with_number)

      result = described_class.new(
        to: user.phone_number,
        from: "+18282519900",
        body: "Test message",
        media_urls: ["https://kimmel.com/ruby.jpg"]
      ).call

      expect(result.success?).to be(true)
      message = Message.first
      expect(message.media.count).to eq(1)
    end

    it "does not receive a message if the to number is invalid" do
      result = described_class.new(
        to: "+18282519900",
        from: "+18285555000",
        body: "Test message"
      ).call

      expect(Contact.count).to eq(0)
      expect(Conversation.count).to eq(0)
      expect(Message.count).to eq(0)
      expect(result.success?).to be(false)
      expect(result.errors).not_to be_empty
    end
  end

  def use_fake_downloader
    downloader = spy(from_url: Result.success(
      file: open("./spec/fixtures/files/ruby.jpg"),
      extension: ".jpg"
    ))
    stub_const("DownloadFile", downloader)
  end
end

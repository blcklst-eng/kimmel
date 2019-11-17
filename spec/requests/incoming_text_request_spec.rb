require "rails_helper"

RSpec.describe "Incoming Text API", :as_twilio, type: :request do
  describe "POST #create" do
    context "with valid params" do
      it "adds a message to an existing conversation" do
        user = create(:user_with_number)
        contact = create(:contact, user: user, phone_number: "+18285555000")
        conversation = create(:conversation, user: user, contact: contact)

        post incoming_text_url, params: {
          To: user.phone_number,
          From: contact.phone_number,
          Body: "test",
        }

        message = Message.first
        expect(message.body).to eq("test")
        expect(conversation.reload.messages.count).to eq(1)
        expect(response).to have_http_status(:created)
      end

      it "creates a message with media" do
        use_fake_downloader
        user = create(:user_with_number)
        contact = create(:contact, user: user, phone_number: "+18285555000")
        create(:conversation, user: user, contact: contact)

        post incoming_text_url, params: {
          To: user.phone_number,
          From: contact.phone_number,
          Body: "",
          NumMedia: 1,
          MediaContentType0: "image/jpeg",
          MediaUrl0: "https://kimmel.com/ruby.jpg",
        }

        message = Message.first
        expect(message.media.size).not_to eq(0)
        expect(message.media.first.content_type). to eq("image/jpeg")
      end
    end

    context "with invalid params" do
      it "returns a 400 without a body" do
        user = create(:user_with_number)
        create(:contact, user: user, phone_number: "+18285555000")

        post incoming_text_url, params: {To: user.phone_number, From: "+18285555000"}

        expect(response).to have_http_status(400)
      end

      it "returns a 400 when the user does not exist" do
        post incoming_text_url, params: {To: "+18282519900", From: "+18285555000"}

        expect(response).to have_http_status(400)
      end
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

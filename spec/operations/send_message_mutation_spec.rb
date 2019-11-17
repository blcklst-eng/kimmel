require "rails_helper"

describe "Send Message Mutation API", :graphql, :active_storage do
  describe "sendMessage" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: SendMessageInput!) {
          sendMessage(input: $input) {
            conversation {
              mostRecentMessage {
                body
              }
            }
          }
        }
      GRAPHQL
    end

    it "sends a text message to the provided phone number" do
      stub_const("TwilioAdapter", fake_adapter)
      user = build(:user_with_number)

      result = execute query, as: user, variables: {
        input: {
          to: "(828) 251-9900",
          body: "Test message",
        },
      }

      expect(Message.count).to eq(1)
      expect(Conversation.count).to eq(1)
      body = result[:data][:sendMessage][:conversation][:mostRecentMessage][:body]
      expect(body).to eq("Test message")
    end

    it "sends an mms to the provided phone number" do
      stub_const("TwilioAdapter", fake_adapter)
      user = build(:user_with_number)
      media = create_blob

      execute query, as: user, variables: {
        input: {
          to: "(828) 251-9900",
          media: [media.signed_id],
        },
      }

      message = OutgoingMessage.first
      expect(message.media.count).to eq(1)
    end
  end

  def fake_adapter
    spy(
      lookup: LookupResult.new(phone_number: "+18282519900"),
      send_message: SendMessageResult.new(sent?: true)
    )
  end
end

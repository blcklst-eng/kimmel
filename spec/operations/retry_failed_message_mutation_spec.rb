require "rails_helper"

describe "Retry Failed Message Mutation API", :graphql do
  describe "retryFailedMessage" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: RetryFailedMessageInput!) {
          retryFailedMessage(input: $input) {
            message {
              body
              status
            }
          }
        }
      GRAPHQL
    end

    it "sends a failed message again" do
      stub_const("TwilioAdapter", fake_adapter)
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)
      message = create(:outgoing_message, conversation: conversation, status: :failed)

      result = execute query, as: user, variables: {
        input: {
          id: message.id,
        },
      }

      new_message = result[:data][:retryFailedMessage][:message]
      expect(new_message[:body]).to eq(message.body)
      expect(new_message[:status]).to eq("SENT")
      expect(message.reload).to be_deleted
    end
  end

  def fake_adapter
    spy(send_message: SendMessageResult.new(sent?: true))
  end
end

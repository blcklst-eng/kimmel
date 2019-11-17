require "rails_helper"

RSpec.describe RetryFailedMessage do
  describe "#call" do
    it "sends a new message and deletes the failed message" do
      failed_message = create(:outgoing_message, status: :failed)
      subject = described_class.new(
        failed_message,
        messenger: double(send_message: SendMessageResult.new(sent?: true))
      )

      result = subject.call

      new_message = result.message
      expect(result.success?).to be(true)
      expect(new_message.status).to eq("sent")
      expect(new_message.body).to eq(failed_message.body)
      expect(new_message.to).to eq(failed_message.to)
      expect(new_message.from).to eq(failed_message.from)
      expect(failed_message).to be_deleted
    end

    it "does not retry if the message is not failed" do
      delivered_message = create(:outgoing_message, status: :delivered)
      subject = described_class.new(
        delivered_message,
        messenger: double(send_message: SendMessageResult.new(sent?: true))
      )

      result = subject.call

      expect(result.success?).to be(false)
      expect(delivered_message).not_to be_deleted
    end

    it "does not delete the failed message if sending fails" do
      failed_message = create(:outgoing_message, status: :failed)
      subject = described_class.new(
        failed_message,
        messenger: double(send_message: SendMessageResult.new(sent?: false, error: "error"))
      )

      result = subject.call

      expect(result.success?).to be(false)
      expect(failed_message).not_to be_deleted
    end
  end
end

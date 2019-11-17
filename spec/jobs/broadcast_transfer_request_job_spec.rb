require "rails_helper"

describe BroadcastTransferRequestJob, type: :job do
  describe "#perform" do
    it "triggers a subscription notification to the user" do
      schema = stub_const("MessagingSchema", spy)
      transfer_request = create(:transfer_request)

      described_class.new.perform(transfer_request)

      expect(schema).to have_received(:trigger).with(
        any_args,
        hash_including(scope: transfer_request.receiver.id)
      )
    end
  end
end

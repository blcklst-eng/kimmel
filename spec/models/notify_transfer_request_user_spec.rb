require "rails_helper"

describe NotifyTransferRequestUser, type: :model do
  describe "#call" do
    it "should create a call if the user is available" do
      transfer_request_call = stub_const("CreateTransferRequestCall", spy(call: Result.success))
      user = create(:user_with_number)
      transfer_request = create(:transfer_request, receiver: user)

      result = described_class.new(transfer_request).call

      expect(result.success?).to be(true)
      expect(transfer_request_call).to have_received(:call)
    end

    it "should broadcast a transfer request if the user is not available" do
      user = create(:user_with_number)
      create(:incoming_call, :in_progress, user: user)
      transfer_request = create(:transfer_request, receiver: user)

      expect {
        result = described_class.new(transfer_request).call
        expect(result.success?).to be(true)
      }.to have_enqueued_job(BroadcastTransferRequestJob)
    end
  end
end

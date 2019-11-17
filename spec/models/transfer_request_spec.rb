require "rails_helper"

describe TransferRequest, type: :model do
  context "validations" do
    it "is valid with valid attributes" do
      expect(build(:transfer_request)).to be_valid
    end
  end

  describe "#should_ask?" do
    it "returns true when the user has active calls" do
      user = create(:user)
      create(:incoming_call, :in_progress, user: user)
      transfer_request = create(:transfer_request, receiver: user)

      result = transfer_request.should_ask?

      expect(result).to be(true)
    end

    it "returns false when the user has no active calls" do
      transfer_request = create(:transfer_request)

      result = transfer_request.should_ask?

      expect(result).to be(false)
    end
  end

  describe "#respond" do
    it "should update the response" do
      transfer_request = create(:transfer_request)

      transfer_request.respond("Fake Response")

      expect(transfer_request.reload.response).to eq("Fake Response")
    end

    it "should broadcast transfer request to the user" do
      transfer_request = create(:transfer_request)

      expect {
        transfer_request.respond("Fake Response")
      }.to have_enqueued_job(BroadcastTransferRequestResponseJob)
    end
  end
end

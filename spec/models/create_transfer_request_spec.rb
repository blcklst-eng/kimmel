require "rails_helper"

describe CreateTransferRequest, type: :model do
  describe ".call" do
    it "creates a transfer request" do
      operator = build(:user)
      recipient = build(:user)
      contact = create(:contact, user: recipient)
      participant = create(:participant, contact: contact)
      call = create(:incoming_call, participants: [participant], user: operator)
      create(:incoming_call, :in_progress, user: recipient)

      result = described_class.new(
        participant: call.participants.first,
        receiver: recipient
      ).call

      expect(TransferRequest.count).to be(1)
      transfer_request = TransferRequest.first
      expect(transfer_request.participant).to eq(participant)
      expect(transfer_request.receiver).to eq(recipient)
      expect(transfer_request.contact).to eq(contact)
      expect(result.success?).to be(true)
    end
  end
end

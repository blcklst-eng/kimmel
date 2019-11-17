class CreateTransferRequest
  def initialize(participant:, receiver:)
    @participant = participant
    @receiver = receiver
  end

  def call
    transfer_request = TransferRequest.new(
      participant: participant,
      receiver: receiver,
      contact: receiver_contact
    )

    if transfer_request.save
      NotifyTransferRequestUser.new(transfer_request).call
    else
      Result.failure("Failed to create transfer request")
    end
  end

  private

  attr_reader :participant, :receiver

  def receiver_contact
    Contact.from(phone_number: participant.phone_number, user: receiver)
  end
end

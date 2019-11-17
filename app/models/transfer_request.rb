class TransferRequest < ApplicationRecord
  belongs_to :participant
  belongs_to :receiver,
    class_name: "User",
    foreign_key: :receiver_id,
    inverse_of: false
  belongs_to :request_call, class_name: "Call", optional: true

  has_one :incoming_call,
    source: :call,
    through: :participant
  has_one :requestor,
    source: :user,
    through: :incoming_call
  belongs_to :contact, inverse_of: false

  def should_ask?
    receiver.active_calls?
  end

  def respond(response)
    transaction { update(response: response) }.tap do |result|
      broadcast_transfer_request_response if result
    end
  end

  private

  def broadcast_transfer_request_response
    BroadcastTransferRequestResponseJob.perform_later(self)
  end
end

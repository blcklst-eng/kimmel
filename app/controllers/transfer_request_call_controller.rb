class TransferRequestCallController < ApplicationController
  def store
    result = receive_transfer_call

    if result.success?
      render xml: result.response, status: :created
    else
      render status: :bad_request
    end
  end

  private

  def receive_transfer_call
    transfer_request = TransferRequest.find(params[:id])
    phone_number = PhoneNumber.find_by!(number: params[:To])

    phone_number.receive_transfer_request_call(
      transfer_request: transfer_request,
      from: params[:From],
      sid: params[:CallSid]
    )
  end
end

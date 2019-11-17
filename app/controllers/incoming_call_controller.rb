class IncomingCallController < ApplicationController
  include ValidateTwilioRequest

  def create
    phone_number = PhoneNumber.find_by!(number: params[:To])
    result = phone_number.receive_incoming_call(
      from: params[:From],
      sid: params[:CallSid]
    )

    if result.success?
      render xml: result.response, status: :created
    else
      render status: :bad_request
    end
  end
end

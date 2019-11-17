class TransferParticipantController < ApplicationController
  include ValidateTwilioRequest

  def store
    result = ReceiveCall.new(voice_args).call

    if result.success?
      render xml: result.response, status: :created
    else
      render status: :bad_request
    end
  end

  private

  def voice_args
    {
      to: PhoneNumber.find_by!(number: params[:to]),
      from: params[:from],
      sid: params[:CallSid],
    }
  end
end

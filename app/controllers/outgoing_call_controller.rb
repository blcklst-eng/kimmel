class OutgoingCallController < ApplicationController
  include ValidateTwilioRequest

  def create
    result = MakeCall.new(voice_args).call

    if result.success?
      render xml: result.response, status: :created
    else
      render status: :bad_request
    end
  end

  private

  def voice_args
    {
      to: params[:To],
      from: params[:From],
      sid: params[:CallSid],
    }
  end
end

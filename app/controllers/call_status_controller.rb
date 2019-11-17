class CallStatusController < ApplicationController
  include ValidateTwilioRequest

  def store
    call = Call.find(params[:FriendlyName].to_i)
    event = BuildConferenceEvent.from(status_params)
    event.apply(call)

    render status: :ok
  end

  private

  def status_params
    {
      event: params[:StatusCallbackEvent],
      sid: params[:CallSid],
      conference_sid: params[:ConferenceSid],
    }.compact
  end
end

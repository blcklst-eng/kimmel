class QueueCallController < ApplicationController
  include ValidateTwilioRequest

  def store
    if hangup?
      call = FindCallBySid.new(id: params[:call_id], sid: params[:CallSid]).find
      call.hangup
    end

    render status: :ok
  end

  private

  def hangup?
    params[:QueueResult] == "hangup"
  end
end

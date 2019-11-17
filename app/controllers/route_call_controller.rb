class RouteCallController < ApplicationController
  include ValidateTwilioRequest

  def store
    status = CallStatus.from_twilio(params[:CallStatus])
    call = Call.find(params[:call_id])
    call.router.new(call: call, status: status).call
  end
end

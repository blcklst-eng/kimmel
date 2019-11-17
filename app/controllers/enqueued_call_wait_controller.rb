class EnqueuedCallWaitController < ApplicationController
  include ValidateTwilioRequest

  def show
    render xml: RingbackToneResponse.new.to_s, status: :ok
  end
end

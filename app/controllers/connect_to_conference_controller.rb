class ConnectToConferenceController < ApplicationController
  include ValidateTwilioRequest

  def store
    call = Call.find(params[:call_id])

    render xml: DialIntoConferenceResponse.new(call).to_s, status: :ok
  end
end

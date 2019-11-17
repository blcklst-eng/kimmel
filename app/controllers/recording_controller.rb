class RecordingController < ApplicationController
  include ValidateTwilioRequest

  def store
    result = CreateRecording.new(recording_args).call

    if result.success?
      render status: :created
    else
      render status: :bad_request
    end
  end

  private

  def recording_args
    {
      call: call,
      sid: params[:RecordingSid],
      url: params[:RecordingUrl],
      duration: params[:RecordingDuration],
    }
  end

  def call
    Call.find(params[:call_id])
  end
end

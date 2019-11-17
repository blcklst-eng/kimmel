class VoicemailController < ApplicationController
  include ValidateTwilioRequest

  def create
    render xml: VoicemailResponse.new(call).to_s, status: :created
  end

  def store
    result = CreateVoicemail.new(voicemail_store_args).call

    if result.success?
      render status: :created
    else
      render status: :bad_request
    end
  end

  private

  def voicemail_store_args
    {
      incoming_call: call,
      url: params[:RecordingUrl],
      recording_sid: params[:RecordingSid],
    }
  end

  def call
    @call ||= FindCallBySid.new(id: params[:call_id], sid: params[:CallSid]).find
  end
end

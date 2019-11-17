class MessageStatusController < ApplicationController
  include ValidateTwilioRequest

  def create
    message = Message.find(params[:message_id])
    message.update_status(message_status)
    render status: :ok
  end

  private

  def message_status
    MessageStatus.new(status_params[:MessageStatus])
  end

  def status_params
    params.permit(:MessageStatus)
  end
end

class IncomingTextController < ApplicationController
  include ValidateTwilioRequest

  def create
    result = ReceiveMessage.new(message_args).call

    if result.success?
      render status: :created
    else
      render status: :bad_request
    end
  end

  private

  def message_args
    {
      to: params[:To],
      from: params[:From],
      body: params[:Body],
      media_urls: media_params,
    }
  end

  def media_params
    Array.new(params[:NumMedia].to_i) do |i|
      params["MediaUrl#{i}"]
    end
  end
end

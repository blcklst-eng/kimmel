class WalterController < ApplicationController
  before_action :authorize

  def store
    result = SendMessageFromWalter.new(walter_message_args).call

    if result.success?
      render json: {success: true}, status: :created
    else
      render json: {success: false, errors: result.errors}, status: :bad_request
    end
  end

  private

  attr_reader :result

  def authorize
    return true if params[:token]&.eql?(walter_token)

    render json: {success: false, errors: ["Invalid Token"]}, status: :unauthorized
  end

  def walter_token
    Rails.application.credentials[:walter_token]
  end

  def walter_message_args
    {
      contact_args: contact_args,
      body: params[:body],
      user_walter_id: params[:user_walter_id],
    }
  end

  def contact_args
    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      phone_number: params[:to],
      walter_id: params[:contact_walter_id],
    }
  end
end

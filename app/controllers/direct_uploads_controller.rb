class DirectUploadsController < ActiveStorage::DirectUploadsController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def create
    super
  end

  private

  def blob_params
    params.require(:blob).permit(
      :filename,
      :'content-type',
    )
  end

  # Rescue the Auth Error
  def not_authorized
    render json: {error: "Not authorized"}, status: :unauthorized
  end
end

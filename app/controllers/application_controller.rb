class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do
    render json: {errors: "not found"}, status: :not_found
  end
end

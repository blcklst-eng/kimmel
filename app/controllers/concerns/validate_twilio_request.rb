module ValidateTwilioRequest
  extend ActiveSupport::Concern

  included do
    before_action :validate_twilio_request
  end

  def validate_twilio_request
    twilio_signature = request.headers["X-Twilio-Signature"]
    return render status: :bad_request if twilio_signature.nil?

    render status: :unauthorized unless valid_twilio_request?(twilio_signature)
  end

  private

  def valid_twilio_request?(twilio_signature)
    validator = Twilio::Security::RequestValidator.new
    validator.validate(requested_url, twilio_params, twilio_signature)
  end

  def requested_url
    full_url = request.original_url
    return full_url unless request.post?

    full_url.split("?").first
  end

  def twilio_params
    return {} unless request.post?

    params.select { |key| key.to_s.match(/([A-Z][a-z0-9]+)+/) }
      .permit!
      .to_h
      .sort
  end
end

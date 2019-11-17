module TwilioRequest
  def post(uri, params: {}, headers: {}, &block)
    headers["X-Twilio-Signature"] = twilio_request_validator.build_signature_for(uri, params.sort)
    super(uri, params: params, headers: headers, &block)
  end

  def get(uri, params: {}, headers: {}, &block)
    headers["X-Twilio-Signature"] = if params.empty?
      twilio_request_validator.build_signature_for(uri, {})
    else
      twilio_request_validator.build_signature_for(
        "#{uri}?#{params.to_query}",
        {}
      )
    end

    super(uri, params: params, headers: headers, &block)
  end

  def twilio_request_validator
    Twilio::Security::RequestValidator.new
  end
end

class TwilioCapabilityTokenGenerator
  TTL_SECONDS = 4.hours.seconds

  def initialize(identifier)
    @identifier = identifier.to_s
  end

  def call
    capability = Twilio::JWT::ClientCapability.new(account_sid, auth_token, ttl: TTL_SECONDS)
    capability.add_scope(incoming_scope)
    capability.add_scope(outgoing_scope)

    capability.to_s
  end

  private

  attr_reader :identifier

  def incoming_scope
    Twilio::JWT::ClientCapability::IncomingClientScope.new(identifier)
  end

  def outgoing_scope
    Twilio::JWT::ClientCapability::OutgoingClientScope.new(application_sid, identifier)
  end

  def auth_token
    get_credential(:auth_token)
  end

  def account_sid
    get_credential(:account_sid)
  end

  def application_sid
    get_credential(:application_sid)
  end

  def get_credential(credential)
    Rails.application.credentials.dig(Rails.env.to_sym, :twilio, credential)
  end
end

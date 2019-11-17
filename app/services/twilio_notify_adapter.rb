class TwilioNotifyAdapter
  def initialize
    @client = Twilio::REST::Client.new
    @service = client.notify.services(notify_sid)
  end

  def register_device(identity:, type:, address:)
    service.bindings.create(
      identity: identity,
      binding_type: type,
      address: address
    )
  rescue Twilio::REST::RestError
    false
  end

  def send(to:, title:, body:, badge: 1, data: {})
    service.notifications.create(
      TwilioNotification.new(to: to, title: title, body: body, badge: badge, data: data).payload
    )
  end

  private

  attr_reader :client, :service

  def notify_sid
    Rails.application.credentials.dig(Rails.env.to_sym, :twilio, :notify_sid)
  end
end

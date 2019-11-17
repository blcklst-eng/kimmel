class SendPingMessageJob < ApplicationJob
  queue_as :default

  def perform(phone_number)
    adapter = TwilioAdapter.new
    adapter.send_message(
      to: "+18084004547",
      from: phone_number.number,
      body: "Ping Message"
    )
  end
end

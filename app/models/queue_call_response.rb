class QueueCallResponse
  def initialize(call:)
    @call = call
    @response = Twilio::TwiML::VoiceResponse.new
  end

  def to_s
    call.greeting(response)
    response.enqueue(
      name: "queue",
      wait_url: RouteHelper.enqueued_call_wait_url,
      wait_url_method: "GET",
      action: RouteHelper.queue_call_url(call)
    )
    response.to_s
  end

  private

  attr_reader :call, :response
end

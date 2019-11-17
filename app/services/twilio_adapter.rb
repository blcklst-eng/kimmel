class TwilioAdapter
  def initialize
    @client = Twilio::REST::Client.new
  end

  def lookup(phone_number)
    number = phone_number.delete("^0-9")
    result = client.lookups.phone_numbers(number).fetch
    LookupResult.new(phone_number: result.phone_number)
  rescue Twilio::REST::RestError
    LookupResult.new(phone_number: nil)
  end

  def send_message(to:, from:, body: nil, media_url: nil, status_url: nil)
    client.messages.create(
      to: to,
      from: from,
      body: body,
      media_url: Array.wrap(media_url),
      status_callback: status_url
    )
    SendMessageResult.new(sent?: true)
  rescue Twilio::REST::RestError => e
    SendMessageResult.new(sent?: false, error: e.error_message)
  end

  def create_call(url:, to:, from:, **options)
    participant = @client.calls.create(
      url: url,
      to: to,
      from: from,
      **options
    )
    CallResult.new(sid: participant.sid, connected?: true)
  rescue Twilio::REST::RestError => e
    CallResult.new(connected?: false, error: e.error_message)
  end

  def end_conference(conference_sid)
    conference = @client.conferences(conference_sid).fetch
    conference.update(status: "completed") if conference.status != "completed"
    true
  rescue Twilio::REST::RestError
    false
  end

  def update_conference_participant(conference_sid, participant_sid, params: {})
    @client.conferences(conference_sid).participants(participant_sid).update(params)
    true
  rescue Twilio::REST::RestError
    false
  end

  def update_call(sid:, url:, method: "POST")
    @client.calls(sid).update(url: url, method: method)
    true
  rescue Twilio::REST::RestError
    false
  end

  def cancel_call(sid)
    call = @client.calls(sid).fetch
    call = call.update(status: "canceled") unless call_completed?(call.status)

    if call.status == "canceled"
      true
    else
      end_call(sid)
    end
  rescue Twilio::REST::RestError
    false
  end

  def end_call(sid)
    call = @client.calls(sid).fetch
    call.update(status: "completed") unless call_completed?(call.status)
    true
  rescue Twilio::REST::RestError
    false
  end

  def request(url)
    response = JSON.parse(
      @client.request("api.twilio.com", "80", "GET", url).to_json
    ).with_indifferent_access
    Result.success(body: response[:body])
  rescue Twilio::REST::RestError
    Result.failure("Failed to fetch URL")
  end

  private

  attr_reader :client

  def call_completed?(status)
    ["canceled", "completed", "failed", "busy", "no-answer"].include?(status)
  end
end

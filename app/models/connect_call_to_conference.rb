class ConnectCallToConference
  def initialize(call:, sids:, adapter: TwilioAdapter.new)
    @connecting_call = call
    @sids = sids
    @adapter = adapter
  end

  def call
    connected_sids = sids.map { |sid|
      if connect_to_conference(sid)
        sid
      end
    }.compact

    if connected_sids === sids
      Result.success(connected: connected_sids, failed: [])
    else
      Result.failure(
        "Could not connect all calls",
        connected: connected_sids,
        failed: sids - connected_sids
      )
    end
  end

  private

  attr_reader :connecting_call, :sids, :adapter

  def connect_to_conference(sid)
    adapter.update_call(
      sid: sid,
      url: RouteHelper.connect_to_conference_url(connecting_call)
    )
  end
end

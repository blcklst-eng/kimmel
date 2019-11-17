class UpdateUserEvent
  def initialize(payload)
    @payload = JSON.parse(payload)
  end

  def valid?
    payload["type"] == "user_updated"
  end

  def user
    {
      origin_id: user_data["id"].to_i,
      walter_id: user_data["walter_id"],
      intranet_id: user_data["intranet_id"],
      email: user_data["email"],
      first_name: user_data["preferred_name"],
      last_name: user_data["last_name"],
    }
  end

  private

  attr_reader :payload

  def user_data
    payload["user"]
  end
end

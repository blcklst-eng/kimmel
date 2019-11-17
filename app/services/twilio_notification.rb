class TwilioNotification
  def initialize(to:, title:, body:, badge:, data: {})
    @to = to
    @title = title
    @body = body
    @badge = badge
    @data = data
  end

  def payload
    {
      identity: to,
      title: title,
      body: body,
      sound: "default",
      priority: "high",
      data: data.merge(fcm_channel),
      fcm: fcm_payload,
      apn: apn_payload,
    }
  end

  private

  attr_reader :to, :title, :body, :badge, :data

  def apn_payload
    {
      aps: {
        alert: {
          title: title,
          body: body,
        },
        badge: badge,
      },
    }
  end

  def fcm_payload
    {
      notification: {
        title: title,
        body: body,
      }.merge(fcm_channel),
    }
  end

  def fcm_channel
    {
      android_channel_id: "messaging",
      priority: "high",
    }
  end
end

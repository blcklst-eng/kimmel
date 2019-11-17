class StatsCallNotificationJob < ApplicationJob
  queue_as :default

  def perform(call)
    endpoint = Rails.application.config.try(:stats_notification_endpoint)
    HTTP.post(endpoint, params: stats_params(call)) if endpoint
  end

  private

  def stats_params(call)
    {
      intranet_id: call.user.intranet_id,
      contact_number: call.original_participant.phone_number,
      is_outgoing: call.is_a?(OutgoingCall),
      duration: call.duration,
    }
  end
end

class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    result = MessagingSchema.execute(
      data["query"],
      context: context,
      variables: ensure_hash(data["variables"]),
      operation_name: data["operationName"]
    )
    add_subscriber(result)
    transmit(payload(result))
  end

  def unsubscribed
    @subscription_ids.each do |id|
      MessagingSchema.subscriptions.delete_subscription(id)
    end
  end

  private

  def context
    {
      current_user: current_user,
      current_user_id: current_user.id,
      channel: self,
    }
  end

  def add_subscriber(result)
    @subscription_ids << context[:subscription_id] if result.context[:subscription_id]
  end

  def payload(result)
    {
      result: result.subscription? ? {data: nil} : result.to_h,
      more: result.subscription?,
    }
  end

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      string_param(ambiguous_param)
    when Hash
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def string_param(ambiguous_param)
    if ambiguous_param.present?
      ensure_hash(JSON.parse(ambiguous_param))
    else
      {}
    end
  end
end

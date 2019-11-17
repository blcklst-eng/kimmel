class UpdateUserConsumer < Racecar::Consumer
  subscribes_to "user"

  def process(message)
    event = UpdateUserEvent.new(message.value)

    if event.valid?
      User.where(origin_id: event.user[:origin_id])
        .first
        .update!(event.user)
    else
      false
    end
  end
end

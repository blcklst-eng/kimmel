class CreateUserConsumer < Racecar::Consumer
  subscribes_to "user"

  def process(message)
    event = CreateUserEvent.new(message.value)

    if event.valid?
      User.where(origin_id: event.user[:origin_id])
        .first_or_initialize
        .update!(event.user)
    else
      false
    end
  end
end

class RegisterPushNotificationDeviceMutation < Types::BaseMutation
  description "Registers a device to receive push notifications"

  argument :address, String, required: true
  argument :binding_type, String, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    result = RegisterPushNotificationDeviceForUser.new(current_user).call(
      address: input.address,
      type: input.binding_type
    )

    if result.success?
      {success: true, errors: []}
    else
      {success: false, errors: result.errors}
    end
  end
end

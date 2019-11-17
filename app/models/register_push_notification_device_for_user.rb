class RegisterPushNotificationDeviceForUser
  def initialize(user, notify: TwilioNotifyAdapter.new)
    @user = user
    @notify = notify
  end

  def call(address:, type:)
    result = notify.register_device(identity: user.id, address: address, type: type)

    if result
      Result.success
    else
      Result.failure("Failed to register device")
    end
  end

  private

  attr_reader :user, :notify
end

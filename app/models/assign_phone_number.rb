class AssignPhoneNumber
  def initialize(user:, phone_number: nil)
    @user = user
    @phone_number = phone_number
  end

  def call
    return Result.failure("Invalid phone number") if phone_number.blank?

    if user.update(number: phone_number)
      send_welcome
      Result.success(user: user)
    else
      Result.failure(user.errors)
    end
  end

  private

  attr_reader :user

  def phone_number
    @phone_number ||= @phone_number || PhoneNumber.unassigned.first
  end

  def send_welcome
    SendWelcomeEmailJob.perform_later(user.id)
  end
end

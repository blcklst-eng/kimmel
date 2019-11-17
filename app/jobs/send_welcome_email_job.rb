class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)

    WelcomeMailer.welcome_email(user: user).deliver_now
  end
end

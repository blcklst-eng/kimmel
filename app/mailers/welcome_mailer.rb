class WelcomeMailer < ApplicationMailer
  def welcome_email(user:)
    @user = user

    mail(to: @user.email, subject: "Welcome To Kimmel Nexus!")
  end
end

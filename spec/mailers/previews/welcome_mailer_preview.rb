# Preview all emails at http://localhost:3000/rails/mailers/welcome_mailer
class WelcomeMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.first

    WelcomeMailer.welcome_email(user: user)
  end
end

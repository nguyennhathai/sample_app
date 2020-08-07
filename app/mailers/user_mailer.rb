class UserMailer < ApplicationMailer
  def account_activation user
    @user = user

    mail to: user.email, subject: t ".activation.subject"
  end

  def password_reset
    @greeting = t ".activation.greeting"
    mail to: "to@example.org"
  end
end

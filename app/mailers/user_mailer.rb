class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("activation.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("password_resets.password_reset")
  end
end

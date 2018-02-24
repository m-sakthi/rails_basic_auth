class UserMailer < ApplicationMailer
  URL = AppSettings[:authentication][:account_activation_via_web] ?
    AppSettings[:asset_host][:web_url] :
    AppSettings[:asset_host][:url]
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.activation.subject
  #
  def activation(user)
    @user = user
    @url = URL + AppSettings[:authentication][:activation_path] + @user.activation_token
    mail to: @user.email, subject: _('mailer.user_mailer.activation.subject')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    @url = URL + AppSettings[:authentication][:password_reset_path] + @user.reset_token
    mail to: @user.email, subject: _('mailer.user_mailer.password_reset.subject')
  end
end

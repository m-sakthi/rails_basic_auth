MAILER_CONFIG = Rails.application.config_for(:mailer).deep_symbolize_keys!

Rails.application.config.action_mailer.default_url_options = { 
	host: MAILER_CONFIG[:host_with_port],
	protocol: MAILER_CONFIG[:protocol] }

if MAILER_CONFIG[:smtp][:enabled]
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = MAILER_CONFIG[:smtp][:settings]
end
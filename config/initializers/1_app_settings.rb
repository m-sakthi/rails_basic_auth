# This file will be loaded first while booting the app.
# Specify your app settings in app_settings.yml
AppSettings = HashWithIndifferentAccess.new(Rails.application.config_for(:app_settings))

def build_url()
  custom_port = 
    ![443, 80].include?(AppSettings[:port].to_i) ?
    ":#{AppSettings[:port]}" : nil

  app_path =
    [ AppSettings[:protocol],
      "://",
      AppSettings[:host],
      custom_port,
      AppSettings[:relative_url_root],
    ].join('')
end

AppSettings[:url] = build_url()
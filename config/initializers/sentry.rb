# Be sure to restart your server when you modify this file.

require 'gitlab/current_settings'

def configure_sentry
  # allow it to fail: it may do so when create_from_defaults is executed before migrations are actually done
  begin
    sentry_enabled = Gitlab::CurrentSettings.current_application_settings.sentry_enabled
  rescue
    sentry_enabled = false
  end

  if sentry_enabled
    Gitlab::Sentry.configure!(
      dsn: Gitlab::CurrentSettings.current_application_settings.sentry_dsn)
  end
end

configure_sentry if Rails.env.production?

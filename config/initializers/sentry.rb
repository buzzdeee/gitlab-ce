# Be sure to restart your server when you modify this file.

require 'gitlab/current_settings'

# allow it to fail: it may do so when create_from_defaults is executed before migrations are actually done
begin
  sentry_enabled = Gitlab::CurrentSettings.current_application_settings.sentry_enabled
rescue
  sentry_enabled = false
end

program_context = 
  if Sidekiq.server?
    'sidekiq'
  else
    'rails'
  end

Gitlab::Sentry.configure!(
  sentry_enabled: sentry_enabled && Rails.env.production?,
  dsn: Gitlab::CurrentSettings.current_application_settings.sentry_dsn,
  program: program_context)

require './spec/support/sidekiq'

# In the case where no ApplicationSetting record exists and the (Redis) cache is
# cold, two ApplicationSetting records can be created in the same transaction
# when creating a user because the following two methods trigger an
# ApplicationSetting record creation:
#   1. default_value_for(:external)
#   2. after_initialize :set_projects_limit

# That's why we eager-load the current application settings so that:
#   1. An ApplicationSetting record is created (if needed) in the DB
#   2. The (Redis) cache is warmed up
Gitlab::CurrentSettings.current_application_settings

Gitlab::Seeder.quiet do
  User.seed do |s|
    s.id = 1
    s.name = 'Administrator'
    s.email = 'admin@example.com'
    s.notification_email = 'admin@example.com'
    s.username = 'root'
    s.password = '5iveL!fe'
    s.admin = true
    s.projects_limit = 100
    s.confirmed_at = DateTime.now
  end
end

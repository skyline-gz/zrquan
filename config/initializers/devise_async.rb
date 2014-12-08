application_config_file = File.join(Rails.root,'config','application.yml')
raise "#{application_config_file} is missing!" unless File.exists? application_config_file
application_config = YAML.load_file(application_config_file)[Rails.env].symbolize_keys

# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox, :backburner, :que
Devise::Async.setup do |config|
  config.enabled = application_config[:enable_devise_async]
  config.backend = :sidekiq
  # Let you specify a custom queue where to enqueue your background Devise jobs. Defaults to :mailer.
  # :sidekiq backend doesn't register worker. see:https://github.com/mhfs/devise-async/issues/46
  config.queue = :default
end
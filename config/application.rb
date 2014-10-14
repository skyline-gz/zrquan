require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zrquan
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
		config.time_zone = 'Beijing'
		config.active_record.default_timezone = :local
  end
end

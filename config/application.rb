require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zrquan
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/caches)

		config.time_zone = 'Beijing'
		config.active_record.default_timezone = :local
    config.i18n.default_locale = :"zh-CN"

    # devise respond_to json
    config.to_prepare do
      DeviseController.respond_to :html, :json
    end
  end
end

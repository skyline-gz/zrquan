require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Zrquan
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/app/caches)
    config.autoload_paths += %W(#{config.root}/app/workers)

		config.time_zone = 'Beijing'
		config.active_record.default_timezone = :local
    config.i18n.default_locale = :'zh-CN'

    # devise respond_to json
    config.to_prepare do
      DeviseController.respond_to :html, :json
    end

    #禁用active_support全局的对输出json时自动转换html标签tag
    # Todo:  需要自定义方法对用户输入进行区别化的XSS防范
    config.active_support.escape_html_entities_in_json = false
  end
end

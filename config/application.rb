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

    config.middleware.delete 'Rack::Cache'   # 整页缓存，用不上
    # config.middleware.delete 'Rack::Lock'    # 多线程加锁，多进程模式下无意义
    # config.middleware.delete 'Rack::Runtime' # 记录X-Runtime（方便客户端查看执行时间）
    config.middleware.delete 'ActionDispatch::RequestId' # 记录X-Request-Id（方便查看请求在群集中的哪台执行）
    config.middleware.delete 'ActionDispatch::RemoteIp'  # IP SpoofAttack
    # config.middleware.delete 'ActionDispatch::Callbacks' # 在请求前后设置callback
    # config.middleware.delete 'ActionDispatch::Head'      # 如果是HEAD请求，按照GET请求执行，但是不返回body
    config.middleware.delete 'Rack::ConditionalGet'      # HTTP客户端缓存才会使用
    config.middleware.delete 'Rack::ETag'    # HTTP客户端缓存才会使用
    config.middleware.delete 'ActionDispatch::BestStandardsSupport' # 设置X-UA-Compatible, 在nginx上设置

    #禁用active_support全局的对输出json时自动转换html标签tag
    # Todo:  需要自定义方法对用户输入进行区别化的XSS防范
    config.active_support.escape_html_entities_in_json = false
  end
end

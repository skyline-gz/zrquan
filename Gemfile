#source 'https://rubygems.org'
source 'https://ruby.taobao.org/'

# rails默认系列gem
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'

# 前端系列gem
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Compass CSS Framework
gem 'compass-rails', '2.0.0'
# Ensure import Compass modules once
gem 'compass-import-once', '1.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# javascript库：jquery
gem 'jquery-rails', '3.1.0'

# 后端系列gem
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
# A simple configuration / settings solution that uses an ERB enabled YAML file.
gem 'settingslogic', '2.0.9'

# 默认暂时不用的gem
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'　与较多的前端库产生冲突，暂不使用
# 此处使用了百度的富内容编辑器Ueditor
# gem 'rails_kindeditor', '0.4.5'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
# gem 'devise-encryptable', '0.2.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use unicorn as the app server
# gem 'unicorn'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Use debugger
# gem 'debugger', group: [:development, :test]
# Use API Server
# gem 'grape', '0.7.0'
# gem 'grape-entity', '0.4.4'


# 数据库
gem 'mysql2', '~> 0.3.17'
# gem 'pg', '0.17.1'

# 测试
group :development, :test do
	# 比guard更轻量的自动start/restart工具，用于调试sidekiq workers
	gem 'rerun', '0.10.0'
	gem 'rspec', '~> 3.1.0'
	gem 'rspec-rails', '~> 3.1.0'
	gem 'guard-rspec', '~> 4.3.1'
  gem 'database_cleaner'
	gem 'factory_girl_rails', '~> 4.4.1'
	gem 'spork-rails'
	gem 'guard-spork'
end

# 用户认证
gem 'devise', '3.2.4'
# 异步发送邮件认证
gem 'devise-async', '0.9.0'

# 用户权限
gem 'cancancan', '~> 1.9.2'

# 服务器
gem 'thin', group: :development

# 分页
gem 'will_paginate', '~> 3.0.5'

# 搜索引擎
gem 'sunspot_rails', '2.1.1'
gem 'sunspot_solr', '2.1.1'

# Pub/Sub消息队列
gem 'faye', '1.0.1'

#Simple, efficient background processing for Ruby http://sidekiq.org
gem 'sidekiq', '2.17.7'

# 图片处理及上传
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '3.7.0'
gem 'carrierwave-qiniu', '0.1.4'

# 拼音处理
gem 'ruby-pinyin', '0.4.3'
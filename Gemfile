#source 'https://rubygems.org'
source 'https://ruby.taobao.org/'

# rails默认系列gem
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# 默认暂时不用的gem
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
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


# 数据库：postgresql
gem 'pg', '0.17.1'

# javascript库：jquery
gem 'jquery-rails', '3.1.0'

# 测试
group :development, :test do
	gem 'rspec', '~> 3.1.0'
	gem 'rspec-rails', '~> 3.1.0'
	gem 'guard-rspec', '~> 4.3.1'
  gem 'database_cleaner'
	gem 'factory_girl_rails', '~> 4.4.1'
	gem 'spork-rails'
	gem 'guard-spork'
end

# 用户系统（认证及权限）
gem 'devise', '3.2.4'
gem 'devise-encryptable', '0.2.0'
gem 'cancan', '1.6.10'

# 服务器
gem 'thin', group: :development

# 分页
gem 'will_paginate', '~> 3.0.5'

# 富内容编辑
gem 'rails_kindeditor', '0.4.5'

# 省市级联
gem 'china_city'

# 搜索引擎
gem 'sunspot_rails', '2.1.1'
gem 'sunspot_solr', '2.1.1'

# 消息队列
gem 'faye', '1.0.1'

# 头像及图片上传
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '3.7.0'

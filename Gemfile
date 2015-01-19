#source 'https://rubygems.org'
source 'https://ruby.taobao.org/'

# rails默认系列gem
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.9'

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
# Embed the V8 Javascript Interpreter into Ruby
# gem 'therubyracer',  platforms: :ruby
# Use unicorn as the app server
# gem 'unicorn'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Use debugger
# gem 'debugger', group: [:development, :test]
# API Framework
# gem 'grape', '0.7.0'
# gem 'grape-entity', '0.4.4'


# 数据库
gem 'mysql2', '~> 0.3.17'

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

# a Ruby binding for the OpenBSD bcrypt() password hashing algorithm, allowing you to easily store a secure hash of your users' passwords.
gem 'bcrypt', '~> 3.1.9'

# JSON Web Token implementation in Ruby
gem 'jwt', '~> 1.2.0'

# 用户权限
gem 'cancancan', '~> 1.9.2'

# 服务器
gem 'thin', group: :development

# 搜索引擎
gem 'sunspot_rails', '2.1.1'
gem 'sunspot_solr', '2.1.1'

#Simple, efficient background processing for Ruby http://sidekiq.org
gem 'sidekiq', '2.17.7'

# 图片处理及上传
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '3.7.0'
gem 'carrierwave-qiniu', '0.1.4'

# 拼音处理
gem 'ruby-pinyin', '0.4.3'

# 在控制台中打印进度条，rake sunspot:reindex[,model] 命令强依赖
gem 'progress_bar', '1.0.3'
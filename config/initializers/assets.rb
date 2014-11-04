# 开放assets下所有js和css的访问权限
Rails.application.config.assets.precompile += [/.*\.js/,/.*\.css/];


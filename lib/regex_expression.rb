module RegexExpression
  # https://ruby-china.org/topics/410 尽量不要用^和$来判断字符串的开始和结尾,用\A和\z
  MOBILE = /\A1[0-9]{10}\z/             #1开头的11位数字
  PASSWORD = /\A[a-zA-Z0-9]{8,20}\z/       #8～20位的字符和数字
end
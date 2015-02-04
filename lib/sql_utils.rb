module SqlUtils
  # 将变量绑定到sql中
  def self.escape_sql(*sql)
    ActiveRecord::Base.send(:sanitize_sql_array, sql)
  end
end
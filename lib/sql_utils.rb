module SqlUtils
  # 转换日期为yyyymmdd的整数类型
  def self.escape_sql(*sql)
    ActiveRecord::Base.send(:sanitize_sql_array, sql)
  end
end
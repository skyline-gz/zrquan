module DateUtils
  # 转换日期为yyyymmdd的整数类型
  def self.to_yyyymmdd(date)
    date.strftime("%Y%m%d").to_i
  end

  # 转换日期为yyyymmddhhmmss的整数类型
  def self.to_yyyymmddhhmmss(date)
    date.strftime("%Y%m%d%H%M%S").to_i
  end
end
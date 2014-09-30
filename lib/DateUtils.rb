module DateUtils
  # 转换日起为yyyymmdd的整数类型
  def to_yyyymmdd(date)
    date.strftime("%Y%m%d").to_i    
  end
end
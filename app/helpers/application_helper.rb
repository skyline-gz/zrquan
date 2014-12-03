module ApplicationHelper
  # 生成姓名
  def generate_name(first_name, last_name)
    if check_english(first_name)|| check_english(last_name)
      first_name + ' ' + last_name
    else
      first_name + last_name
    end
  end

  def to_full_time(date)
    date.strftime("%F %I:%M %p")
  end

  private
  def check_english(str)
    /\A[a-zA-Z]+\z/.match(str) != nil
  end
end

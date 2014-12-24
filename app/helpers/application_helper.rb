module ApplicationHelper

  def to_full_time(date)
    date.strftime("%F %I:%M %p")
  end

end

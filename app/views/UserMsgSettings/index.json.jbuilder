json.array!(@user_msg_settings) do |user_msg_setting|
  json.extract! user_msg_setting, :id, :followed_flag, :agreed_flag, :commented_flag, :answer_flag, :pm_flag
  json.url user_msg_setting_url(user_msg_setting, format: :json)
end

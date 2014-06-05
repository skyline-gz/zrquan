json.array!(@user_settings) do |user_setting|
  json.extract! user_setting, :id, :followed_flag, :aggred_flag, :commented_flag, :answer_flag, :pm_flag
  json.url user_setting_url(user_setting, format: :json)
end

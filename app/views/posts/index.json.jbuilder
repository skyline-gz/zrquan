json.array!(@posts) do |post|
  json.extract! post, :id, :token_id, :content, :agree_score, :oppose_score, :anonymous_flag, :user_id, :edited_at
  json.url post_url(post, format: :json)
end

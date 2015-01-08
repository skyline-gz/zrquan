json.array!(@post_comments) do |post_comment|
  json.extract! post_comment, :id, :content, :agree_score, :oppose_score, :anonymous_flag, :user_id, :replied_comment_id
  json.url post_comment_url(post_comment, format: :json)
end

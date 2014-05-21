json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :user_id, :commentable_id, :commentable_type
  json.url comment_url(comment, format: :json)
end

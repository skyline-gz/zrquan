json.code 'S_OK'
json.data @comments do |comment|
  json.user_name generate_name(comment.user.first_name,comment.user.last_name)
  json.user_avatar Settings.upload_url + comment.user.avatar
  json.is_author comment.user.id == @comment_related_obj.user.id
  json.content comment.content
  json.updated_at comment.updated_at
end

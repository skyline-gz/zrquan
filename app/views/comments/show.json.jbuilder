json.code 'S_OK'
json.data @comments do |comment|
  json.id comment.id
  json.user_id comment.user.token_id
  json.user_url_id comment.user.url_id
  json.user_name generate_name(comment.user.first_name,comment.user.last_name)
  if comment.user.avatar
    json.user_avatar Settings.upload_url + comment.user.avatar
  else
    json.user_avatar '/images/noface.gif'
  end

  json.is_author comment.user.id == @comment_related_obj.user.id
  json.content comment.content
  json.updated_at comment.updated_at
  if current_user
    json.is_self comment.user.id == current_user.id
  end
  if comment.replied_comment_id
    reply_comment = Comment.find(comment.replied_comment_id)
    if reply_comment
      json.is_reply true
      json.reply_user_id reply_comment.user.token_id
      json.reply_user_url_id reply_comment.user.url_id
      json.reply_user_name generate_name(reply_comment.user.first_name, reply_comment.user.last_name)
    else
      json.is_reply false
    end
  else
    json.is_reply false
  end
end

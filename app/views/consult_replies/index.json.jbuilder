json.array!(@consult_replies) do |consult_reply|
  json.extract! consult_reply, :id, :consult_subject_id, :content, :user_id
  json.url consult_reply_url(consult_reply, format: :json)
end

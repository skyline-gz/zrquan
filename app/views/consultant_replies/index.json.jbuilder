json.array!(@consultant_replies) do |consultant_reply|
  json.extract! consultant_reply, :id, :consultant_subject_id, :reply_seq, :content, :user_id
  json.url consultant_reply_url(consultant_reply, format: :json)
end

json.array!(@messages) do |message|
  json.extract! message, :id, :content, :type, :user_id
  json.url message_url(message, format: :json)
end

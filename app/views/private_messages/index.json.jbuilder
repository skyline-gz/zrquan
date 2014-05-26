json.array!(@private_messages) do |private_message|
  json.extract! private_message, :id, :content, :user1_id, :user2_id, :send_class, :read_flag
  json.url private_message_url(private_message, format: :json)
end

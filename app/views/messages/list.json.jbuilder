json.code 'S_OK'
message_block_templates = []
@messages.each do |key, messages|
  template = render partial: 'messages/messages_day_block', :locals => {:day_key =>key, :messages => messages}
  message_block_templates.push(template)
end
json.data message_block_templates

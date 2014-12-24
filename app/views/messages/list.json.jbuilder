json.code 'S_OK'
messageblock_templates = []
@messages.each do |key, messages|
  template = render partial: 'messages/messagedayblock', :locals => {:day_key =>key, :messages => messages}
  messageblock_templates.push(template)
end
json.data messageblock_templates

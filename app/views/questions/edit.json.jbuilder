json.code 'S_OK'
json.data do
  json.test "<>"
  json.id @question.id
  json.title @question.title
  json.content @question.content
  json.themes @question_themes do |question_theme|
    if question_theme.theme
      json.id question_theme.theme.id
      json.name question_theme.theme.name
    end
  end
end

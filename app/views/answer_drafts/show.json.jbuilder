json.code 'S_OK'
json.data do
  json.content @answer_draft.content
  json.question_id @question.token_id
end
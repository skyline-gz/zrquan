json.code 'S_OK'
infoblock_templates = []
@questions.each do |question|
  if question.recommend_answer
    infoblock_templates. push render partial: 'partials/infoblock', :locals => {:question => question, \
                :answer => question.recommend_answer}
  else
    infoblock_templates. push json.data render partial: 'partials/infoblock', :locals => {:question => question}
  end
end
json.data infoblock_templates
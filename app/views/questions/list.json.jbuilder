json.code = 'S_OK'
template_array = []
@questions.each do |question|
  if question.recommend_answer
    template_array. push render partial: 'partials/infoblock', :locals => {:question => question, \
                :answer => question.recommend_answer}
  else
    template_array. push json.data render partial: 'partials/infoblock', :locals => {:question => question}
  end
end
json.data template_array
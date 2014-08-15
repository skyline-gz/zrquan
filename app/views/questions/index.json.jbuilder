json.array!(@questions) do |question|
  json.extract! question, :id, :title, :content, :theme_id, :industry_id, :category_id, :answer_num, :user_id
  json.url question_url(question, format: :json)
end

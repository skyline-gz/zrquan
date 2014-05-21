json.array!(@articles) do |article|
  json.extract! article, :id, :title, :content, :agree_score, :theme_id, :industry_id, :category_id, :mark_flag, :user_id
  json.url article_url(article, format: :json)
end

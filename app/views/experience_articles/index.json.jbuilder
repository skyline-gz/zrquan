json.array!(@experience_articles) do |experience_article|
  json.extract! experience_article, :id, :title, :content, :agree_score, :theme_id, :industry_id, :category_id, :mark_flag, :user_id
  json.url experience_article_url(experience_article, format: :json)
end

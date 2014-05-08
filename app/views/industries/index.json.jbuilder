json.array!(@industries) do |industry|
  json.extract! industry, :id, :name
  json.url industry_url(industry, format: :json)
end

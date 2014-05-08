json.array!(@consultant_subjects) do |consultant_subject|
  json.extract! consultant_subject, :id, :title, :content, :theme_id, :mentor_id, :apprentice_id, :mentor_stat_flag, :user_stat_flag
  json.url consultant_subject_url(consultant_subject, format: :json)
end

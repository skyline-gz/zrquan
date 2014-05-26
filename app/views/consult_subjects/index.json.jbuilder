json.array!(@consult_subjects) do |consult_subject|
  json.extract! consult_subject, :id, :title, :content, :theme_id, :mentor_id, :apprentice_id, :mentor_stat_flag, :user_stat_flag
  json.url consult_subject_url(consult_subject, format: :json)
end

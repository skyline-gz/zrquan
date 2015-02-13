json.code 'S_OK'
json.results do
  json.user do
    json.id @user.id
    json.name @user.name
    json.mobile @user.mobile
    json.avatar Settings.upload_url + @user.avatar
  end
end
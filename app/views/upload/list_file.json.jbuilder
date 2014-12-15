json.state 'SUCCESS'
list = []
@file_infos.each do |file_info|
  list.push({:url => Settings.upload_url + file_info.url, :original => file_info.original_name})
end
json.list list
json.start @start
json.total @file_infos.length
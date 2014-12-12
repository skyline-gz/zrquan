# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  storage :qiniu

  #
  def filename
    @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
    @name + '.' + file.extension
  end

  def name
    @name
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "uploads/avatars/" + current_user.id
    # "#{model.user.first_name}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.title}"
    # 存储格式应该是　http://zrquan.qiniudn.com/uploads/user/avatars/user.id
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(doc docx xls xlsx ppt pptx pdf)
  end

end

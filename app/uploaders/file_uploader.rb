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
    # 存储格式应该是　http://zrquan.qiniudn.com/uploads/files/user.token_id
    "uploads/#{mounted_as}/#{model.token_id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(doc docx xls xlsx ppt pptx pdf)
  end

end

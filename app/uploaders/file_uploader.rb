# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  storage :qiniu

  def filename
    @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
    @name + '.' + file.extension
  end

  def name
    @name
  end

  def store_dir
    # 存储格式应该是　http://zrquan.qiniudn.com/uploads/files/user.token_id
    "uploads/#{mounted_as}/#{model.token_id}"
  end

  def extension_white_list
    %w(doc docx xls xlsx ppt pptx pdf)
  end

end

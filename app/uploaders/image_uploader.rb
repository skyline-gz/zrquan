# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog
  storage :qiniu

  # self.qiniu_bucket = "zrquan"
  # self.qiniu_bucket_domain = "zrquan.qi.com"
  # self.qiniu_protocal = 'http'
  # self.qiniu_can_overwrite = true
  # self.qiniu_bucket_private= true #default is false

  # def filename
  #   if original_filename
  #     @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
  #     "#{@name}.#{file.extension}"
  #   end
  # end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "uploads/avatars/" + current_user.id
    # "#{model.user.first_name}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.title}"
    # 存储格式应该是　http://zrquan.qiniudn.com/uploads/user/avatars/user.id
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :resize_to_fit => [50, 50]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :large do
  #   process :resize_to_fit => [100, 100]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

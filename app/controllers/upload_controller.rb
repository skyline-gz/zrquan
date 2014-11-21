require 'digest/md5'
require 'mime/types'
require 'tempfile'

class UploadController < ApplicationController
  # respond_to :html, :xml, :json
  before_action :authenticate_user!
  # 允许iframe跨域请求
  # see http://stackoverflow.com/questions/18445782/how-to-override-x-frame-options-for-a-controller-or-action-in-rails-4?rq=1
  after_action :allow_iframe


  def upload_avatar
    case params["handle_mode"]
      when 'save'
        create_and_save_tempfile(params["picture"].read, params["picture"].content_type)
        return
      when 'cache'
        uploaded_avatar = params["picture"].read
        cache_obj = {:content_type => params["picture"].content_type, :fileblob => uploaded_avatar}
        dest_id = Digest::MD5.hexdigest(uploaded_avatar)
        UploadCache.instance.write(dest_id, cache_obj)
        @image_url = request.protocol + request.host_with_port + '/upload/preview_avatar?dest_id=' + dest_id
        @dest_id = dest_id
        render template: 'users/show.av_iframe'
        return
      when 'resize'
        crop_avatar
        return
      else
    end
  end

  def preview_avatar
    key = params['dest_id']
    cache_obj = UploadCache.instance.read(key)
    if cache_obj
      send_data cache_obj[:fileblob], :type => cache_obj[:content_type], :disposition => 'inline'
      return
    end
    render text: 'cache expired'
  end

private
  def crop_avatar
    key = params['dest_id']
    w = params['w']
    h = params['h']
    x = params['x']
    y = params['y']
    cache_obj = UploadCache.instance.read(key)
    if cache_obj
      image = MiniMagick::Image.read(cache_obj[:fileblob])
      image.crop("#{w}x#{h}+#{x}+#{y}")
      image.background("#ffffff00")
      image.flatten
      image.resize "100x100"

      create_and_save_tempfile(image.to_blob, cache_obj[:content_type])
      return
    end
    render text: "cache expired"
  end

  def create_and_save_tempfile (file_blob, content_type)
    # 利用md5构造唯一的文件名及临时文件
    type = MIME::Types[content_type].first.extensions.first

    dest_id = Digest::MD5.hexdigest(file_blob)
    tempfile = Tempfile.new([dest_id, "\." + type], '/tmp')
    File.open(tempfile, "wb") do |f|
      f.write file_blob
    end

    # 存储到七牛云
    uploader = AvatarUploader.new(current_user, "avartars")
    uploader.store!(tempfile)

    file_path = uploader.file.path
    current_user.avatar = file_path
    current_user.save

    # 释放临时文件
    tempfile.close
    tempfile.unlink
    render :json => {:code => 'S_OK', :url => Settings.upload_url + file_path}
  end

  def allow_iframe
    # response.headers.except! 'X-Frame-Options'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM ' + request.protocol + request.host_with_port
  end
end
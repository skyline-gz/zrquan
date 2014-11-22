require 'digest/md5'
require 'mime/types'
require 'tempfile'

class UploadController < ApplicationController
  # respond_to :html, :xml, :json
  before_action :authenticate_user!
  # 允许iframe跨域请求
  # see http://stackoverflow.com/questions/18445782/how-to-override-x-frame-options-for-a-controller-or-action-in-rails-4?rq=1
  after_action :allow_iframe

  # 上传流程
  # 客户端先判断是否支持HTML5 Canvas截图和FileReader，则在前端用JCrop得到截图坐标后然后canvas截图，然后做如下调用
  # picture: fileblob
  # handle_mode: 'save'
  # 返回经过七牛持久化的头像url
  # 若不支持HTML5（IE6~9） 则分两次调用，第一次，将图片缓存到服务器端，返回暂时可访问的URL
  # picture: file
  # handle_mode: 'cache'
  # 返回本地头像缓存（缓存3分钟）的url，以及dest_id以供下次调用
  # 第二次向服务器发送Jcrop返回的截图坐标，在服务器端进行截图
  # dest_id: 图片fileblob hash
  # w h x y 使用Jcrop得到
  # 返回经过七牛持久化的头像url
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
      # see http://www.imagemagick.org/script/convert.php
      image.background("#ffffff00")
      image.flatten
      image.extent("#{w}x#{h}+#{x}+#{y}")
      image.resize "100x100!"
      create_and_save_tempfile(image.to_blob, image.mime_type)
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

    if current_user.avatar
      CarrierWave::Storage::Qiniu::File.new(uploader, current_user.avatar).delete
    end

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
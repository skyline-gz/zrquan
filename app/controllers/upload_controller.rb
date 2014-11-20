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
    uploaded_avatar = params["picture"].read
    if params["handle_mode"] == 'save'
      # 利用md5构造唯一的文件名及临时文件
      type = MIME::Types[params["picture"].content_type].first.extensions.first
      destid = Digest::MD5.hexdigest(uploaded_avatar)
      tempfile = Tempfile.new([destid, "\." + type], '/tmp')
      File.open(tempfile, "wb") do |f|
        f.write uploaded_avatar
      end
      # 测试七牛云存储
      uploader = AvatarUploader.new(current_user, "avartars")
      uploader.store!(tempfile)

      file_path = uploader.file.path
      current_user.avatar = file_path
      current_user.save

      # 释放临时文件
      tempfile.close
      tempfile.unlink
      render :json => {:code => 'S_OK', :url => Settings.upload_url + file_path}
      return
    end
    cache_obj = {:content_type => params["picture"].content_type, :fileblob => uploaded_avatar}
    # File.read(:content_type => params["picture"])
    destid = Digest::MD5.hexdigest(uploaded_avatar)
    UploadCache.instance.write(destid, cache_obj)
    # render :json => {:code => "S_OK", :destId => destid}
    # render html: '<b>html goes here<b/>'.html_safe
    render html: ('<script>parent.tempAvatarUrl = "http://localhost:3000/upload/preview_avatar/' + destid + '";alert("123")</script>').html_safe
  end

  def preview_avatar
    key = params["destid"]
    cache_obj = UploadCache.instance.read(key)
    if cache_obj
      # 利用md5构造唯一的文件名及临时文件
      type = MIME::Types[cache_obj[:content_type]].first.extensions.first
      tempfile = Tempfile.new([key, "\." + type], '/tmp')
      File.open(tempfile, "wb") do |f|
        f.write cache_obj[:fileblob]
      end

      # file.write(cache_obj[:fileblob])

      # 测试七牛云存储
      uploader = AvatarUploader.new(@user, "avartars")
      uploader.store!(tempfile)
      # 释放临时文件

      tempfile.close
      tempfile.unlink
      send_data cache_obj[:fileblob], :type => cache_obj[:content_type], :disposition => 'inline'
      return
    end
    render text: "cache expired"
  end

  def crop_avatar
    key = params["destid"]
    w = params["w"]
    h = params["h"]
    x = params["x"]
    y = params["y"]
    cache_obj = UploadCache.instance.read(key)
    if cache_obj
      image = MiniMagick::Image.read(cache_obj[:fileblob])
      # image.crop '#{w}x#{h}+#{x}+#{y}'
      image.crop('10x10+10+10')
      send_data image.to_blob, :type => 'image/png',:disposition => 'inline'
      return
    end
    render text: "cache expired"
  end

private
  def allow_iframe
    # response.headers.except! 'X-Frame-Options'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM http://localhost:8888'
  end
end
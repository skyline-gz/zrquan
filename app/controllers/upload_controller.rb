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
    case params["handle_mode"]
      when 'save'
        # 利用md5构造唯一的文件名及临时文件
        type = MIME::Types[params["picture"].content_type].first.extensions.first
        dest_id = Digest::MD5.hexdigest(uploaded_avatar)
        tempfile = Tempfile.new([dest_id, "\." + type], '/tmp')
        File.open(tempfile, "wb") do |f|
          f.write uploaded_avatar
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
        return
      when 'cache'
        cache_obj = {:content_type => params["picture"].content_type, :fileblob => uploaded_avatar}
        dest_id = Digest::MD5.hexdigest(uploaded_avatar)
        UploadCache.instance.write(dest_id, cache_obj)
        temp_avatar_url = request.protocol + request.host_with_port + '/upload/preview_avatar?dest_id=' + dest_id
        #返回到iframe中执行
        #Todo 将此部分放在views里面，再render
        render html: ('<script>parent.Zrquan.Users.Show.resizeAvatarModalView.showModal("resizeAvatarModal",{\'url\':\''
        +temp_avatar_url + '\',\'dest_id\':\''+ dest_id + '\'});</script>').html_safe
        return
      when 'resize'

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
      image.crop('10x10+10+10')
      send_data image.to_blob, :type => 'image/png',:disposition => 'inline'
      return
    end
    render text: "cache expired"
  end

  def allow_iframe
    # response.headers.except! 'X-Frame-Options'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM ' + request.protocol + request.host_with_port
  end
end
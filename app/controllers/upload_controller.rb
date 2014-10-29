require 'digest/md5'

class UploadController < ApplicationController
  # respond_to :html, :xml, :json
  # 允许iframe跨域请求
  # see http://stackoverflow.com/questions/18445782/how-to-override-x-frame-options-for-a-controller-or-action-in-rails-4?rq=1
  after_action :allow_iframe


  def upload_avatar
    uploaded_avatar = params["picture"].read
    cache_obj = {:content_type => params["picture"].content_type, :file => uploaded_avatar}
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
      send_data cache_obj[:file], :type => 'image/png', :disposition => 'inline'
      return
    end
    render text: "cache expired"
  end

  def corp_avatar
    key = params["destid"]
    w = params["w"]
    h = params["h"]
    x = params["x"]
    y = params["y"]
    cache_obj = UploadCache.instance.read(key)
    image = MiniMagick::Image.open(cache_obj[:file])
    image.corp("#{w}x#{h}+#{x}+#{y}")
    send_data image, :type => 'image/png',:disposition => 'inline'
  end

private
  def allow_iframe
    # response.headers.except! 'X-Frame-Options'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM http://localhost:8888'
  end
end
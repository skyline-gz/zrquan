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
    render :json => {:code => "S_OK", :destId => destid}
  end

  def preview_avatar
    key = params["destid"]
    cache_obj = UploadCache.instance.read(key)
    send_data cache_obj[:file], :type => 'image/png',:disposition => 'inline'
  end

private
  def allow_iframe
    # response.headers.except! 'X-Frame-Options'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://localhost:8888'
  end
end
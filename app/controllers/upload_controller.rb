require 'digest/md5'
require 'mime/types'
require 'tempfile'
require 'returncode_define'

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

  # ueditor的配置请求
  def config_editor
    render 'config_editor.json'
  end

  # ueditor 上传图片
  def upload_image
    upload_file = params[:upfile]

    # 存储到七牛云
    uploader = ImageUploader.new(current_user, "images")
    uploader.store!(upload_file)

    # 保存附件的关联
    user_attachment_id = save_user_attachments(upload_file.original_filename, uploader.file.path, \
      upload_file.content_type, uploader.file.size, 'Image')

    type = get_content_type_extensions(upload_file.content_type)
    render :json => {:original => upload_file.original_filename, :url => Settings.upload_url + uploader.file.path, \
                     :name => uploader.filename, :size => uploader.file.size, \
                     :attachId =>user_attachment_id, :type => type, :state => 'SUCCESS'}
    end

    # ueditor 上传附件
    def upload_file
      upload_file = params[:upfile]

      # 存储到七牛云
      uploader = FileUploader.new(current_user, "files")
      uploader.store!(upload_file)

      # 保存附件的关联
      user_attachment_id = save_user_attachments(upload_file.original_filename, uploader.file.path, \
      upload_file.content_type, uploader.file.size, 'Attachment')

      type = get_content_type_extensions(upload_file.content_type)
      render :json => {:original => upload_file.original_filename, :url => Settings.upload_url + uploader.file.path, \
                     :name => uploader.name + '.' + type, :size => uploader.file.size, \
                     :attachId =>user_attachment_id, :type => type , :state => 'SUCCESS'}
    end

    # ueditor 列出该用户已上传的附件信息
    def list_file
      attach_type = params[:attach_type] || 'Attachment'
      start = params[:start].to_i
      size = params[:size].to_i
      @start = start
      @file_infos = current_user.user_attachments.where(:attach_type => attach_type).sort_by{ |q| q.updated_at }.reverse!
      @file_infos[start..start + size - 1]
      render 'list_file'
    end

  private
  def crop_avatar
    key = params['dest_id']
    w = params['w']
    h = params['h']
    x = params['x']
    y = params['y']
    if key == nil || w == nil || h == nil || x == nil || y == nil
      render :json => { :ReturnCode => FA_INVALID_PARAMETERS } and return
    end
    cache_obj = UploadCache.instance.read(key)
    if cache_obj
      image = MiniMagick::Image.read(cache_obj[:fileblob])
      # see http://www.imagemagick.org/script/convert.php
      image.background("#ffffff00")
      image.flatten
      image.extent("#{w}x#{h}+#{x}+#{y}")
      image.resize '100x100!'
      create_and_save_tempfile(image.to_blob, image.mime_type)
      return
    end
    render text: 'cache expired!'
  end

  def create_and_save_tempfile (file_blob, content_type)
    # 利用md5构造唯一的文件名及临时文件
    type = get_content_type_extensions content_type

    dest_id = Digest::MD5.hexdigest(file_blob)
    tempfile = Tempfile.new([dest_id, "\." + type], '/tmp')
    File.open(tempfile, "wb") do |f|
      f.write file_blob
    end
    # 存储到七牛云
    uploader = ImageUploader.new(current_user, "avartars")
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

  def save_user_attachments (original_name, url, content_type, size ,attach_type)
    attach_info = current_user.user_attachments.new
    attach_info.original_name = original_name
    attach_info.url = url
    attach_info.content_type = content_type
    attach_info.size = size
    attach_info.attach_type = attach_type
    attach_info.save
    attach_info.id
  end

  def get_content_type_extensions(content_type)
    MIME::Types[content_type].first.extensions.first
  end

  def allow_iframe
    # response.headers.except! 'X-Frame-Options'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM ' + request.protocol + request.host_with_port
  end
end
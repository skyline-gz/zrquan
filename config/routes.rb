Rails.application.routes.draw do

  resources :posts, except: [:edit, :update, :destroy] do
    member do
      post :agree, :constraints => {:format => 'json'}
      post :oppose, :constraints => {:format => 'json'}
    end
  end

  resources :post_comments, only: [:new, :create] do
    member do
      post :agree, :constraints => {:format => 'json'}
      post :oppose, :constraints => {:format => 'json'}
    end
  end
  # resources :private_messages, except: [:destroy, :edit, :update]

  resources :messages, only: [:index] do
    # 列出消息(ajax)
    collection do
      get :list, :constraints => {:format => 'json'}
    end
  end

  resources :questions, except: [:new, :destroy] do
    # 列出问题(ajax)
    collection do
      get :list, :constraints => {:format => 'json'}
    end
    # 创建答案，修改答案，赞同答案
		resources :answers, only: [:create, :update] do
      member do
        post :agree, :constraints => {:format => 'json'}
      end
    end
    # 获取草稿，删除草稿，保存草稿
    resources :answer_drafts, only: [] do
      collection do
        post :save, :constraints => {:format => 'json'}
        post :remove, :constraints => {:format => 'json'}
        get :fetch, :constraints => {:format => 'json'}
      end
    end
    # 关注，取消关注 问题
    member do
      post :follow, :constraints => {:format => 'json'}
      post :unfollow, :constraints => {:format => 'json'}
    end
  end

  resources :users, only: [] do
    collection do
      # 账号相关
      # 根据手机号码发送认证短信，并在服务器建立手机号码与验证码的哈希，供注册账号或找回密码使用
      get 'send_verify_code' => 'users/account#send_verify_code', :constraints => {:format => 'json'}
      # 注册账户
      post 'registration' => 'users/registration#create', :constraints => {:format => 'json'}
      # 验证客户端token是否合法
      get 'verify' => 'users/session#verify', :constraints => {:format => 'json'}
      # 登陆账号
      post 'session' => 'users/session#create', :constraints => {:format => 'json'}
      # 重置密码(需要提供验证码)
      post 'reset_password' => 'users/account#reset_password', :constraints => {:format => 'json'}
    end
    member do
      get 'questions'
      get 'answers'
      get 'bookmarks'
      get 'drafts'
      get 'profile'
      post 'follow', :constraints => {:format => 'json'}
      post 'unfollow', :constraints => {:format => 'json'}
    end
  end

  # 搜索
  get 'search' => 'search#index'
  # 列出搜索结果(ajax)
  get 'search/list' => 'search#list', :constraints => {:format => 'json'}

  # 收藏,取消收藏　问题，文章
  post 'bookmarks' => 'bookmarks#create', :constraints => {:format => 'json'}
  delete 'bookmarks' => 'bookmarks#destroy', :constraints => {:format => 'json'}


  # 评论问题，评论答案
  get 'comments' => 'comments#show'
  post 'comments' => 'comments#create'
  delete 'comments' => 'comments#destroy'

  # 头像上传
  post 'upload/upload_avatar'
  get 'upload/preview_avatar'

  # ueditor 获取配置，图片上传，附件上传，列出在线附件
  get 'upload/config_editor'
  post 'upload/upload_image'
  post 'upload/upload_file'
  get 'upload/list_file'

  # 创建主题
  post 'themes' => 'themes#create'

  #　自动匹配
  post 'automatch' => 'automatch#do_match', :constraints => {:format => 'json'}

  # 个人设置
  get 'settings' => redirect('settings/profile')

  # 档案设置
  get 'settings/profile' => 'user_settings#show_profile'
  post 'settings/profile' => 'user_settings#update_profile'

  # 省市级联，根据region id获取所有城市
  get 'settings/locations' => 'user_settings#locations'

  # 密码设置
  get 'settings/password' => 'user_settings#show_password'
  post 'settings/password' => 'user_settings#update_password'

  # 私信设置
  get 'settings/notification' => 'user_settings#show_notification'
  post 'settings/notification' => 'user_settings#edit_notification'

  # 为了满足assets pipeline,对于css采用相对路径'../images'等访问
  get 'assets/images/:id' => redirect('assets/%{id}'), constraints: {id: /.*/}
  get 'images/:id' => redirect('assets/%{id}'), constraints: {id: /.*/}

  root 'home#home'
end

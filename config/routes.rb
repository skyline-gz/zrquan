Rails.application.routes.draw do
	#mount ChinaCity::Engine => '/china_city'

  resources :private_messages, except: [:destroy, :edit, :update]

  resources :consult_subjects, except: :destroy do
		member do
			post :accept
			post :close
			post :ignore
		end
	  resources :consult_replies, except: [:edit, :update, :destroy]
	end

	resources :consult_replies, only: [:show, :edit, :update]

  resources :messages, except: [:destroy, :edit, :update]

  resources :questions, except: :destroy do
		resources :answers, except: :destroy
  end

  # 列出问题(ajax)
  get 'list_questions' => 'questions#list'

	resources :answers, only: [:show, :edit, :update] do
		member do
			post :agree
		end
	end

  devise_for :users, controllers:{
      registrations: "users/registrations",
      sessions: "users/sessions",
      confirmations: "users/confirmations",
      passwords: "users/passwords"
  }

  devise_scope :user do
    post 'registrations' => 'users/registrations#create'
    post 'sessions' => 'users/sessions#create'
    delete 'sessions' => 'users/sessions#destroy'
    get 'confirmations/resend' => 'users/confirmations#resend'
  end

  resources :users, except: [:destroy, :create] do
		collection do
			get :verified_users
		end
	end

	resources :relationships, only: [:destroy, :create]

  get '/home/search'
  get '/home/my_bookmark'
  get '/home/my_draft'
  get '/home/activate'

  # 收藏,取消收藏　问题，文章
  post 'bookmarks' => 'bookmarks#create'
  delete 'bookmarks' => 'bookmarks#destroy'


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
  post 'automatch' => 'automatch#do_match'

  # 个人设置
  get 'settings' => redirect('settings/profile')

  # 档案设置
  get 'settings/profile' => 'user_settings#show_profile'
  post 'settings/profile' => 'user_settings#update_profile'

  # 省市级联，根据region id获取所有城市
  get 'settings/locations' => 'user_settings#locations'

  # 密码设置
  get 'settings/password' => 'user_settings#show_password'
  post 'settings/password' => 'users#update_password'

  # 私信设置
  get 'settings/notification' => 'user_settings#show_notification'
  post 'settings/notification' => 'user_settings#edit_notification'

  # 为了满足assets pipeline,对于css采用相对路径'../images'等访问
  get 'assets/images/:id' => redirect('assets/%{id}'), constraints: {id: /.*/}
  get 'images/:id' => redirect('assets/%{id}'), constraints: {id: /.*/}

  root 'home#home'
end

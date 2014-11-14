Rails.application.routes.draw do
	#mount ChinaCity::Engine => '/china_city'

  resources :user_settings, except: [:destroy, :create, :index]

  resources :private_messages, except: [:destroy, :edit, :update]

  resources :user_settings, only: [:edit, :update, :show]

  resources :consult_subjects, except: :destroy do
		member do
			post :accept
			post :close
			post :ignore
		end
	  resources :consult_replies, except: [:edit, :update, :destroy]
	end

	resources :consult_replies, only: [:show, :edit, :update]
 
  resources :articles do
		member do
			post :agree
		end
		resources :comments, only: [:index, :new, :create]
	end

  resources :messages, except: [:destroy, :edit, :update]

  resources :questions, except: :destroy do
		resources :answers, except: :destroy
	end

	resources :answers, only: [:show, :edit, :update] do
		member do
			post :agree
		end
		resources :comments, only: [:index, :new, :create]
	end

  devise_for :users, controllers:{
      registrations: "users/registrations",
      sessions: "users/sessions"
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

	resources :bookmarks, only: [:destroy, :create]
	#post '/relation'
	
	get '/home/search'
	get '/home/my_bookmark'
	get '/home/my_draft'
	get '/home/activate'

  # 头像上传
  post 'upload/upload_avatar'
  get 'upload/preview_avatar'
  get 'upload/crop_avatar'

  # 为了满足assets pipeline,对于css采用相对路径'../images'等访问
  get "assets/images/:id" => redirect("assets/%{id}"), constraints: {id: /.*/}
  get "images/:id" => redirect("assets/%{id}"), constraints: {id: /.*/}

  root 'home#home'

  # mount Zrquan::API => "/"
end

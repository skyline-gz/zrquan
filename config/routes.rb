Rails.application.routes.draw do
	#mount ChinaCity::Engine => '/china_city'

  resources :messages

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

  devise_for :users, controllers:{registrations: "users/registrations"}

  resources :users, except: [:destroy, :create] do
		collection do
			get :mentors
		end
	end

	resources :relationships, only: [:destroy, :create]

	resources :bookmarks, only: [:destroy, :create]
	#post '/relation'
	
	get '/home/search'
	get '/home/my_bookmark'
	get '/home/my_draft'
	get '/home/activate'

  root 'home#home'
end

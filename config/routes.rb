Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
  end
  # get '/api' => redirect('/swagger-ui/dist/index.html?url=http://' + Rails.application.credentials.config[:BASE_URL] + '/apidocs')
  # resources :apidocs, only: [:index]

  devise_for :users, path: '', path_names: {
    sign_in: 'api/v1/users/login',
    sign_out: 'api/v1/users/logout',
    registration: 'api/v1/users/signup'
  }, controllers: { registrations: 'api/v1/users/registrations'}

  scope module: :api, path: :api do
    scope module: :v1, path: :v1 do
      scope module: :admin, path: :admin do
        resources :users, only: [:show, :update]
        resources :hashtags, only: [:create]
        resources :posts, only: [:index, :show, :destroy]
        resources :events, only: [:index, :show, :destroy]
      end
      resources :users do
        collection do
          post :reset_password
          post :send_otp
          post :verify_otp
          post :profile_image
          post :cover_images
          post :google
          delete :signout
        end
      end
      resources :friendships do
        member do
          post :approve
          post :decline
          delete :cancel
        end
      end
      resources :friends do
        collection do
          post :search
          get :feeds
        end
      end
      resources :close_friends, only: [:index, :create]
      resources :roommates, only: [:index, :create, :destroy]
      resources :groups do
        member do
          post :join
          post :add_users
          put :status
          delete :remove_avatar
        end
      end
      resources :likes
      resources :support_tickets
      resources :direct_messages
      resources :messages
      resources :chatroom_users do
        collection do
            post :add_participants
            delete :delete_participant
            put :add_admin_role
            put :remove_admin_role
          end
      end
      resources :chatrooms do
        member do
          get :chatroom_detail
          get :get_media
          get :get_participants
        end
        collection do
          get :users_list
        end
      end
      resources :comments
      resources :posts do
        collection do
          get :audience
          post :search
        end
        member do
          post :report_post
        end
      end
      resources :feelings, only: [:index]
      resources :activities, only: [:index, :show]
      resources :locations, only: [:index] do
        collection do
          post :search
        end
      end
      resources :albums, only: [:index, :create] do
        collection do
          get :audience
        end
      end
      resources :followings, only: [:index, :create, :destroy]
      resources :followers, only: [:index]
      resources :blocks, only: [:index, :create] do
        collection do
          delete :destroy
        end
      end
      resources :permissions, only: [:index]
      resources :privacy_settings, only: [:index] do
        collection do
          post :update
        end
      end
      resources :calendar_events do
        member do
          post :add_media_item
          delete '/remove_media_item/:media_item_id', to: 'calendar_events#remove_media_item'
          put :attendance
        end
        collection do
          get :list
        end
      end
      resource :media_items, only: [:create]
      resources :hashtags, controller: 'hashtag_stats', only: [:index]
    end
  end
end

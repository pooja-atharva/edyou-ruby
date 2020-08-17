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
      resources :users do
        collection do
          post :reset_password
          post :send_otp
          post :verify_otp
          post :profile_image
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
      resources :friends
      resources :groups do
        member do
          post :add_users
        end
      end
      resources :likes
      resources :comments
      resources :posts do
        collection do
          get :audience
        end
      end
      resources :feelings, only: [:index]
      resources :activities, only: [:index, :show]
      resources :albums, only: [:index, :create] do
        collection do
          get :audience
        end
      end
      resources :followings, only: [:index, :create, :destroy]
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
    end
  end
end

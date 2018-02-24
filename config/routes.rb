Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'docs#index'

  post   'login'   =>  'sessions#create'
  delete 'logout'  =>  'sessions#destroy'

  namespace :api do
    namespace :v1 do
      resources :users do
        collection do
          get :profile
          post 'account_activation/:token', to: 'users#account_activation'
        end
        member do
          put :block
          put :activate
        end
      end

      resources :roles do
        collection do
          post :create
          delete :destroy
          get :users_list
        end
      end
    end
  end
end

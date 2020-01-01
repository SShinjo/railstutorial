Rails.application.routes.draw do

# root 'controller_name#action_name'ˆ
  root 'static_pages#home'
  get '/help', to: 'static_pages#help', as:'helf'
  get 'static_pages/about'
  get 'static_pages/contact'

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"

  get '/signup', to:'users#new'
  post '/signup', to: 'users#create'

  # memberを使うとusers/:id/following、collectionを使うとusers/followingとなる
  resources :users, except:[:new] do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

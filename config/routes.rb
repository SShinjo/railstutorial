Rails.application.routes.draw do

# root 'controller_name#action_name'ˆ
  root 'static_pages#home'
  get '/help', to: 'static_pages#help', as:'helf'
  get 'static_pages/about'
  get 'static_pages/contact'
  resources :microposts

  get '/signup', to:'users#new'
  post '/signup', to: 'users#create'
  resources :users, except:[:new]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

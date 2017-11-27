Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'pages#index'
  resources :webhook
  get '/dashboard/page/:page_id/guide', to: 'guide#show', as: 'guide'
  resources :pages, path: '/dashboard/page'
  get '/dashboard/page/:page_id/post/:post_id', to: 'posts#show', as: 'post'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

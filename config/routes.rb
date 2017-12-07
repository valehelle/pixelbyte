Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'pages#index'
  resources :webhook
  get '/dashboard/page/:page_id/guide', to: 'guide#show', as: 'guide'
  get '/privacy', to: 'privacy#show', as: 'privacy'
  resources :pages, path: '/dashboard/page'
  get '/dashboard/page/:page_id/post/:post_id', to: 'posts#show', as: 'post'
  patch '/dashboard/page/:page_id/post/:post_id', to: 'posts#update', as: 'update_post'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

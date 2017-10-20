Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :webhook
  resources :pages, path: '/dashboard/page'
  get '/dashboard/page/:page_id/post/:post_id', to: 'posts#show', as: 'post'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end

Theroot::Application.routes.draw do
  devise_for :users

  resources :users
  resources :comments
  resources :tags
  resources :votes

  get '/t/:tag' => 'main#index', as: :t
  get '/new' => 'main#new', as: :new_thread
  post '/tag_comment' => 'comments#tag_comment', as: :tag_comment

  root to: 'main#home'
end

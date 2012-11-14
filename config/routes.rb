Theroot::Application.routes.draw do
  devise_for :users

  resources :users
  resources :comments do
    member do
      post '/tag_comment' => 'comments#tag_comment', as: :tag_comment
      post '/vote' => 'comments#vote', as: :vote
    end
  end
  resources :tags
  resources :votes

  get '/t/:tag' => 'main#index', as: :t
  get '/new' => 'main#new', as: :new_thread

  root to: 'main#home'
end

Theroot::Application.routes.draw do
  devise_for :users

  resources :users
  resources :comments do
    member do
      post '/tag_comment/:id' => 'comments#tag_comment', as: :tag_comment
    end
  end
  resources :tags
  resources :votes

  match '/t/:tag' => 'main#index', as: :t

  match '/new' => 'main#new', as: :new_thread

  root to: 'main#home'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  devise_for :users
  get 'home/about' => 'homes#about'
  resources :users, only: [:create, :index, :show, :edit, :update]
  resources :books, only: [:new, :create, :index, :show, :edit, :update, :destroy]

end
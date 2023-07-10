Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  devise_for :users
  get 'home/about' => 'homes#about'
  #検索のルーティング
  get "search" => "searches#search"

  resources :users, only: [:create, :index, :show, :edit, :update] do
    #ユーザー一人に対して実行されるものなのでdo~endで
    resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      get "search", to: "users#search"
  end

  resources :books, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    #単数系にするとURLにIDが含まれない。Bookひとつの投稿に対して実行されるものなのでdo~endで囲む
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

end
Rails.application.routes.draw do

  devise_for :users, skip: [:passwords],controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
}

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root :to =>"homes#top"
    get '/about' => "homes#about"
    resources :posts, only: [:new, :index, :show, :create, :destroy, :edit, :update] do
      resource :like, only: [:create, :destroy]
        resources :comments, only: [:create, :destroy]
    end

    resources :users, only: [:edit, :show, :update] do
      member do
        get :liked_posts
      end
      collection do
        get 'check'
        patch 'out'
      end
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    get "search", to: "searches#search"
   end




  # devise_for :users
  # root to: 'homes#top'

  devise_for :admin,skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

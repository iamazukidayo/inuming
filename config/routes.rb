Rails.application.routes.draw do
  devise_for :users, skip: [:passwords],controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
}

  scope module: :public do
    root :to =>"homes#top"
    get '/about' => "homes#about"
    resources :posts, only: [:new, :index, :show, :create, :destroy, :edit, :update] do
      resource :like, only: [:create, :destroy]
    end
    resources :users, only: [:edit, :show, :update] do
      collection do
        get 'check'
        patch 'out'
      end
    end
   end




  # devise_for :users
  # root to: 'homes#top'

  devise_for :admin,skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

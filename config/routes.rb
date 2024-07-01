Rails.application.routes.draw do
  devise_for :users,skip: [:passwords],controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
}

scope module: :public do
  root :to =>"homes#top"
  get '/about' => "homes#about"
end
  

  
  # devise_for :users
  # root to: 'homes#top'
  
  devise_for :admins,skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

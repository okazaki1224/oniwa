Rails.application.routes.draw do
  namespace :admin do
    get 'users/edit'
    get 'users/show'
    get 'users/index'
  end
  namespace :admin do
    get 'posts/edit'
    get 'posts/show'
  end
  namespace :admin do
    get 'homes/top'
  end
devise_for :users,skip: [:passwords], controllers: {
registrations: "public/registrations",
sessions: 'public/sessions'
}

devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

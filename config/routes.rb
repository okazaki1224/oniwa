Rails.application.routes.draw do

post '/guests/guest_sign_in', to: 'public/guests#new_guest'

#deviseは順番に注意
devise_for :users,skip: [:passwords], controllers: {
registrations: "public/registrations",
sessions: 'public/sessions'
}

devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
sessions: "admin/sessions"
}

  namespace :admin do
    root to: 'homes#top'
    #get 'homes/top'
    resources:genres, only:[:index, :create, :edit, :update, :destroy]

    resources:posts, only:[:index, :show, :edit, :update, :destroy] do
      resources:post_comments,only: [:index, :edit, :update]
    end

    resources:users, only:[:index, :show, :edit, :update]

  end

  patch 'users/withdraw' => 'public/users#withdraw', as: "withdraw"

  scope module: :public do
    resources:inquiries,only:[:new, :create]
    post 'inquiries/confirm'=> 'inquiries#confirm',as: "confirm"
    get 'inquiries/thanks' => 'inquiries#thanks',as: "thanks"

    root to: 'homes#top'
    get '/about' => 'homes#about', as: "about"

    resources:post_comments, only:[:index, :edit, :create, :destroy]

    resources:users, only:[:index, :show, :edit, :update] do
      member do
        get :myfavorites
      end
    end

    resources:post_images, only:[:index, :show, :new, :create, :destroy]

    resources:posts, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
      resources:post_comments,only: [:create]
      resource:favorites, only:[:create, :destroy]

      get :search, on: :collection
    end

  end
  get 'users/:id/unsubscribe' => 'public/users#unsubscribe', as: "unsubscribe"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

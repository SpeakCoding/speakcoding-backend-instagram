Rails.application.routes.draw do
  resources :users, only: [:show, :create, :update] do
    collection do
      post :authenticate
    end
    member do
      get :followers, :followees, :posts
      post :follow, :unfollow
    end
  end

  resources :posts, only: [:create, :show, :index, :update] do
    member do
      post :like, :unlike
    end
  end
end

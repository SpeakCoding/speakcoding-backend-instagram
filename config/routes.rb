Rails.application.routes.draw do
  resources :users, only: [:show, :create, :update] do
    collection do
      post :authenticate
      get :search
    end
    member do
      get :followers, :followees, :posts
      post :follow, :unfollow
    end
  end

  resources :posts, only: [:create, :show, :index, :update] do
    member do
      post :like, :unlike, :save, :unsave
    end
    collection do
      get :saved, :tagged
    end
  end

  resources :comments, only: [:create, :update, :destroy]
end

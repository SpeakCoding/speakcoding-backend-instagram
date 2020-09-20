Rails.application.routes.draw do
  resources :users, only: [:show, :create, :update] do
    collection do
      post :authenticate
    end
  end

  resources :posts, only: [:create, :index]
end

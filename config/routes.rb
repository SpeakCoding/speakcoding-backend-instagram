Rails.application.routes.draw do
  resources :users, only: [:create] do
    collection do 
      post :authenticate
    end
  end

  resources :posts, only: [:create, :index]
end

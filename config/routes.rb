Rails.application.routes.draw do
  devise_for :users

  resources :links do
    get :new_link, on: :collection
  end

  root to: "links#index"
end

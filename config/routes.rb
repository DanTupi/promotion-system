Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  #TODO:get 'search', to: 'home#search'
  resources :promotions, only: %i[index show new create 
                                edit update destroy] do
    member do
      post 'approve'  
      post 'generate_coupons'
    end
    get 'search', on: :collection
  end
  
  resources :coupons, only: [] do
    post 'disable', on: :member
  end

  resources :product_categories, only: %i[index show new create
                                          edit update destroy]

  namespace :api do
    namespace :v1 do
      resources :coupons, only: %i[show], param: :code
    end
  end
end

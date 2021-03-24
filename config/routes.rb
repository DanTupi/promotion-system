Rails.application.routes.draw do
  root 'home#index'

  resources :promotions, only: %i[index show new create 
                                edit update destroy] do
    post 'generate_coupons', on: :member
  end

  resources :product_categories, only: %i[index show new create
                                          edit update destroy]
end

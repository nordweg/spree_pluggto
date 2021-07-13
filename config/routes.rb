Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :pluggto_settings do
      get :upload_all_products
    end
  end

  namespace :api do
    resource :pluggto do
      post :notifications
    end
  end
end

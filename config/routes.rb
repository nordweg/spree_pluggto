Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :pluggto_settings do
      get :upload_all_products
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :pluggto do
        post :notifications
      end
    end
  end
end

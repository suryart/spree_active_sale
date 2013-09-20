Spree::Core::Engine.routes.draw do
  # Add this extension's routes here
  namespace :admin do
    resources :active_sales do
      collection do
        get  :search
        post :update_positions
      end
      resources :active_sale_events, :path => :events do
        member do
          put :update_events
        end
        resources :sale_images, :path => :images do
          collection do
            post :update_positions
          end
        end
        resources :sale_products, :path => :products, :only => [:index, :create, :destroy] do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end

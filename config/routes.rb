Spree::Core::Engine.routes.draw do
  # Add this extension's routes here
  namespace :admin do
    resources :active_sales do
      collection do
        get  :eventables
        post :update_positions
      end
      member do
        get :get_children
      end
      resources :active_sale_events do
        member do
          put :update_events
        end
        resources :sale_images do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end

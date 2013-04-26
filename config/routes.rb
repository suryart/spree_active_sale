Spree::Core::Engine.routes.draw do
  # Add this extension's routes here
  namespace :admin do
    resources :active_sales do
      resources :active_sale_events do
        get :eventables, :on => :collection
        resources :sale_images do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end

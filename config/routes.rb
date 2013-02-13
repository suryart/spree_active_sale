Spree::Core::Engine.routes.draw do
  # Add this extension's routes here
  namespace :admin do
    resources :active_sales do
      resources :events do
        get 'eventables', :on => :collection
      end
    end
  end
end

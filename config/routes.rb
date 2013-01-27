Spree::Core::Engine.routes.draw do
  # Add this extension's routes here
  namespace :admin do
    resources :active_sales do
      resources :events
    end
  end
end

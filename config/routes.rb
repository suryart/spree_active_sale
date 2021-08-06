Spree::Core::Engine.routes.draw do
  # Add this extension's routes here
  namespace :admin do
    resources :active_sales, :path => :sales do
      collection do
        get  :search
        post :update_positions
      end
      resources :active_sale_events, :path => :events do
        put :update_events, :on => :member
        resources :sale_images, :path => :images do
          post :update_positions, :on => :collection
        end
        resources :sale_products, :path => :products, :only => [:index, :create, :destroy] do
          post :update_positions, :on => :collection
        end
      end
    end
  end

  resources :active_sales, :path => :sales, :only => [:index, :show]
  get '/:view_type/t/*id', :to => 'taxons#show', :as => :sale_nested_taxons
  get '/sales/t/*id', :to => 'taxons#show', :as => :sales_by_taxon
end

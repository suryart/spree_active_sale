require "spec_helper"

describe Spree::ActiveSalesController do
  describe "routing" do

    it "routes to #index" do
      get("/spree/active_sales").should route_to("spree/active_sales#index")
    end

    it "routes to #new" do
      get("/spree/active_sales/new").should route_to("spree/active_sales#new")
    end

    it "routes to #show" do
      get("/spree/active_sales/1").should route_to("spree/active_sales#show", :id => "1")
    end

    it "routes to #edit" do
      get("/spree/active_sales/1/edit").should route_to("spree/active_sales#edit", :id => "1")
    end

    it "routes to #create" do
      post("/spree/active_sales").should route_to("spree/active_sales#create")
    end

    it "routes to #update" do
      put("/spree/active_sales/1").should route_to("spree/active_sales#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/spree/active_sales/1").should route_to("spree/active_sales#destroy", :id => "1")
    end

  end
end

require 'spec_helper'

describe Spree::HomeController do
  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :spree_api_key => 'fake' }
  let(:sale) { create(:active_sale_with_events, :events_count => 2) }

  before do
    controller.stub :spree_current_user => user
  end

  describe "GET index" do
    it "assigns all active_sale_events as @active_sale_events" do
      spree_get :index
      assigns(:sale_events).should eq(Spree::ActiveSaleEvent.live_active.non_parents.to_a)
      sale.root.children.should eq(Spree::ActiveSaleEvent.live_active.non_parents.to_a)
    end
  end

end

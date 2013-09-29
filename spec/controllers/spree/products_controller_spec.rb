# coding: UTF-8
require 'spec_helper'

describe Spree::ProductsController do
  let!(:user) { mock_model(Spree::User, :spree_api_key => 'fake', :last_incomplete_spree_order => nil) }

  let(:active_sale_event) { create(:active_sale_event_for_product) }
  let(:inactive_sale_event) { create(:inactive_sale_event_for_product) }

  before do
    controller.stub :spree_current_user => user
    user.stub :has_spree_role? => true
  end

  describe "GET show" do
    context "when sale event is live and active" do
      it "then product view page should be accessible" do
        event = active_sale_event
        product = event.products.first
        event.live_and_active?.should be_true
        product.live?.should be_true
        spree_get :show, :id => product.to_param
        response.should be_success
        response.status.should == 200
      end
    end

    context "when sale event is not live and inactive" do
      it "then product view page should not be accessible" do
        event = inactive_sale_event
        product = event.products.first
        event.live_and_active?.should be_false
        product.live?.should be_false
        spree_get :show, :id => product.to_param
        response.should redirect_to(spree.root_path)
      end
    end
  end
end

# coding: UTF-8
require 'spec_helper'

describe Spree::ProductsController do
  stub_authorization!

  let(:active_sale_event) { FactoryGirl.create(:active_sale_event_for_product) }
  let(:inactive_sale_event) { FactoryGirl.create(:inactive_sale_event_for_product) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::ProductsController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  describe "GET show" do
    context "when sale event is live and active" do
      it "then product view page should be accessible" do
        event = active_sale_event
        product = event.eventable
        event.live_and_active?.should be_true
        product.live?.should be_true
        spree_get :show, {:id => product.to_param}, valid_session
        response.should be_success
      end
    end

    context "when sale event is not live and inactive" do
      it "then product view page should not be accessible" do
        event = inactive_sale_event
        product = event.eventable
        event.live_and_active?.should be_false
        product.live?.should be_false
        spree_get :show, {:id => product.permalink}, valid_session
        response.should redirect_to(spree.root_path)
      end
    end
  end
end

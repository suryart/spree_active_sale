# coding: UTF-8
require 'spec_helper'

describe Spree::CheckoutController do
  let(:products) { create_list(:product, 10) }
  let(:order) { FactoryGirl.create(:order_with_totals, :email => nil, :user => nil) }
  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }
  let(:token) { 'some_token' }
  
  let(:active_sale_event) { FactoryGirl.create(:active_sale_event) }
  let(:inactive_sale_event) { FactoryGirl.create(:inactive_sale_event) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::CheckoutController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  before do
    controller.stub :current_order => order
    order.stub :confirmation_required? => true
    @states = ['address', 'delivery', 'payment', 'confirm']
  end

  describe "GET edit" do
    pending "Write some tests for checkout for active_sale_event and inactive_sale_event"
  end
end

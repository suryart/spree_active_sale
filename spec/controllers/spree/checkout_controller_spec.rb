# coding: UTF-8
require 'spec_helper'

describe Spree::CheckoutController do
  let(:token) { 'some_token' }
  let(:user) { stub_model(Spree::LegacyUser) }
  let(:order) { order = FactoryGirl.create(:order_with_totals) }

  before do
    controller.stub :try_spree_current_user => user
    controller.stub :current_order => order
  end
  
  let(:active_sale_event_with_products) { FactoryGirl.create(:active_sale_event_with_products) }

  context "#edit" do
    it 'should check if the event is live for :edit' do
      controller.should_receive(:authorize!).with(:edit, order, token)
      spree_get :edit, { :state => 'address' }, { :access_token => token }
    end
  end
end

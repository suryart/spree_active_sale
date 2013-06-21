# coding: UTF-8
require 'spec_helper'

describe Spree::CheckoutController do
  stub_authorization!
  let(:products) { create_list(:product, 10) }
  let(:order) { create(:order) }
  let(:active_sale_event) { FactoryGirl.create(:active_sale_event) }
  let(:inactive_sale_event) { FactoryGirl.create(:inactive_sale_event) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::CheckoutController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  before do
    controller.stub :spree_current_user => FactoryGirl.create(:user)
    @states = ['address', 'delivery', 'payment', 'confirm']
  end

  describe "GET edit" do
    pending "Write some tests for checkout for active_sale_event and inactive_sale_event"
  end
end

require 'spec_helper'

describe "spree/active_sales/show" do
  before(:each) do
    @spree_active_sale = assign(:spree_active_sale, stub_model(Spree::ActiveSale))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

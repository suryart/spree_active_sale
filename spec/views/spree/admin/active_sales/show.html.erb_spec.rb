require 'spec_helper'

describe "spree/admin/active_sales/show.html.erb" do

  before(:each) do
    @spree_active_sale = assign(:spree_active_sale, stub_model(Spree::ActiveSale))
  end

  it "should render edit" do
    # response.should route_to("spree/admin/active_sales#edit", :id => @spree_active_sale.id)
    # redirect_to([:edit, :admin, @spree_active_sale])
    # spree_get :edit, :id => @spree_active_sale.id
    # current_path.should == [:edit, :admin, @spree_active_sale]
    # render 'edit'
    # assert_select "form", :action => [:admin, @spree_active_sale], :method => "post" do
    # end
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end

require 'spec_helper'

describe Spree::Admin::ActiveSalesController  do
  stub_authorization!

  # This should return the minimal set of attributes required to create a valid
  # Spree::ActiveSale. As you add validations to Spree::ActiveSale, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :name => "Winter festival" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::Admin::ActiveSalesController. Be sure to keep this updated too.
  def valid_session
    {"warden.user.user.key" => session["warden.user.user.key"]}
  end

  describe "#new with valid attributes" do
    before(:each) do
      Spree::ActiveSale.stub!(:new).and_return(@active_sale = mock_model(Spree::ActiveSale, :save=> true))
    end
    
    def do_create
      spree.admin_active_sales_path :create, { :active_sale=> valid_attributes }, valid_session
    end
    
    it "should create the active sale" do
      Spree::ActiveSale.should_receive(:new).with(valid_attributes).and_return(@active_sale)
      do_create
    end
    
    it "should save the active sale" do
      @active_sale.should_receive(:save).and_return(true)
      do_create
    end
    
    it "should be redirect" do
      do_create
      # response.code.should == "302"
    end
    
    it "should assign active_sale" do
      do_create
      # assigns(:active_sale).should == @active_sale
    end
    
    it "should redirect to the index path" do
      do_create
      # assert_redirected_to spree.admin_active_sales_path(assigns(:active_sales))
    end
  end

  describe "GET index" do
    it "assigns all active_sales as @active_sales" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree.admin_active_sales_path :index, {}, valid_session
      assigns(:active_sales).should eq([active_sale])
    end
  end

  describe "GET show" do
    it "assigns the requested active_sale as @active_sale" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree.admin_active_sale_path :show, {:id => active_sale.id}, valid_session
      assigns(:active_sale).should eq(active_sale)
    end
  end

  describe "GET new" do
    it "assigns a new active_sale as @active_sale" do
      spree.new_admin_active_sale_path :new, {}, valid_session
      assigns(:active_sale).should be_a_new(Spree::ActiveSale)
    end
  end

  describe "GET edit" do
    it "assigns the requested active_sale as @active_sale" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree.edit_admin_active_sale_path :edit, {:id => active_sale.to_param}, valid_session
      assigns(:active_sale).should eq(active_sale)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Spree::ActiveSale" do
        expect {
          spree.admin_active_sales_path :create, {:active_sale => valid_attributes}, valid_session
        }.to change(Spree::ActiveSale, :count).by(1)
      end

      it "assigns a newly created active_sale as @active_sale" do
        spree.admin_active_sales_path :create, {:active_sale => valid_attributes}, valid_session
        assigns(:active_sale).should be_a(Spree::ActiveSale)
        assigns(:active_sale).should be_persisted
      end

      it "redirects to the created active_sale" do
        spree.admin_active_sales_path :create, {:active_sale => valid_attributes}, valid_session
        response.should redirect_to(spree.admin_active_sales_path) #(Spree::ActiveSale.last))
      end
    end

    describe "with invalid params" do
      # it "assigns a newly created but unsaved active_sale as @active_sale" do
      #   # Trigger the behavior that occurs when invalid params are submitted
      #   Spree::ActiveSale.any_instance.stub(:save).and_return(false)
      #   spree.admin_active_sales_path :create, {:active_sale => {  }}, valid_session, :method => :post
      #   assigns(:active_sale).should eq(nil) #be_a_new(Spree::ActiveSale)
      # end

      # it "re-renders the 'new' template" do
      #   # Trigger the behavior that occurs when invalid params are submitted
      #   Spree::ActiveSale.any_instance.stub(:save).and_return(false)
      #   spree.admin_active_sales_path :create, {:active_sale => {  }}, valid_session
      #   response.should render_template("admin/active_sales/new")
      # end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      # it "updates the requested active_sale" do
      #   active_sale = Spree::ActiveSale.create! valid_attributes
      #   # Assuming there are no other active_sales in the database, this
      #   # specifies that the Spree::ActiveSale created on the previous line
      #   # receives the :update_attributes message with whatever params are
      #   # submitted in the request.
      #   Spree::ActiveSale.any_instance.should_receive(:update_attributes).with({ "name" => "new sale" })
      #   spree_put :update, {:id => active_sale.to_param, :active_sale => { "name" => "new sale" }}, valid_session
      # end

      it "assigns the requested active_sale as @active_sale" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        spree.admin_active_sale_path :update, {:id => active_sale.to_param, :active_sale => valid_attributes}, valid_session
        assigns(:active_sale).should eq(active_sale)
      end

      it "redirects to the active_sale" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        spree.admin_active_sale_path :update, {:id => active_sale.to_param, :active_sale => valid_attributes}, valid_session
        response.should redirect_to(spree.admin_active_sales_path)
      end
    end

    describe "with invalid params" do
      # it "assigns the active_sale as @active_sale" do
      #   active_sale = Spree::ActiveSale.create! valid_attributes
      #   # Trigger the behavior that occurs when invalid params are submitted
      #   Spree::ActiveSale.any_instance.stub(:save).and_return(false)
      #   spree.admin_active_sale_path :update, {:id => active_sale.to_param, :active_sale => {  }}, valid_session
      #   assigns(:active_sale).should eq(active_sale)
      # end

      # it "re-renders the 'edit' template" do
      #   active_sale = Spree::ActiveSale.create! valid_attributes
      #   # Trigger the behavior that occurs when invalid params are submitted
      #   Spree::ActiveSale.any_instance.stub(:save).and_return(false)
      #   spree_put :update, {:id => active_sale.to_param, :active_sale => {  }}, valid_session
      #   response.should render_template("edit")
      # end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested active_sale" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      expect {
        spree.admin_active_sale_path :destroy, {:id => active_sale.to_param}, valid_session
      }.to change(Spree::ActiveSale, :count).by(-1)
    end

    it "redirects to the active_sales list" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree.admin_active_sale_path :destroy, {:id => active_sale.to_param}, valid_session
      response.should redirect_to(spree.admin_active_sales_path)
    end
  end

end

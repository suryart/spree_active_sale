require 'spec_helper'

describe Spree::Admin::ActiveSalesController  do
  stub_authorization!
  let(:taxon) { create(:taxon) }

  before do
    controller.stub :current_user => FactoryGirl.create(:admin_user)
  end

  # This should return the minimal set of attributes required to create a valid
  # Spree::ActiveSale. As you add validations to Spree::ActiveSale, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { 
      "name" => "Dummy Sale",
      "description"=>"Dummy event description data", 
      "start_date"=> Time.zone.now.strftime("%Y/%m/%d %H:%M:%S %z"), 
      "end_date"=> (Time.zone.now+2.months).strftime("%Y/%m/%d %H:%M:%S %z"), 
      "permalink" => taxon.permalink,
      "eventable_type"=> taxon.class.to_s,
      "eventable_id" => taxon.id.to_s,
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0"
     }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::Admin::ActiveSalesController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  describe "GET index" do
    it "assigns all active_sales as @active_sales" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree_get :index, {}, valid_session
      assigns(:active_sales).include?(active_sale).should be_true
      assigns(:active_sales).should eq(Spree::ActiveSale.all)
    end
  end

  describe "GET show" do
    it "assigns the requested active_sale as @active_sale" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree_get :show, {:id => active_sale.id, :active_sale => active_sale.to_param }, valid_session
      Spree::ActiveSale.any_instance.stub(:errors).and_return('error')
      response.should redirect_to([:edit, :admin, active_sale])
    end
  end

  describe "GET new" do
    it "assigns a new active_sale as @active_sale" do
      spree_get :new, {}, valid_session
      assigns(:active_sale).should be_a_new(Spree::ActiveSale)
    end
  end

  describe "GET edit" do
    it "assigns the requested active_sale as @active_sale" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree_get :edit, {:id => active_sale.to_param, :active_sale => active_sale.to_param}, valid_session
      assigns(:active_sale).should eq(active_sale)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Spree::ActiveSale" do
        expect {
          spree_post :create, {:active_sale => valid_attributes}, valid_session
        }.to change(Spree::ActiveSale, :count).by(1)
      end

      it "assigns a newly created active_sale as @active_sale" do
        spree_post :create, {:active_sale => valid_attributes}, valid_session
        assigns(:active_sale).should be_a(Spree::ActiveSale)
        assigns(:active_sale).should be_persisted
      end

      it "redirects to the created active_sale" do
        spree_post :create, {:active_sale => valid_attributes}, valid_session
        response.should redirect_to([:admin, Spree::ActiveSale])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved active_sale as @active_sale" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSale.any_instance.stub(:save).and_return(false)
        Spree::ActiveSale.any_instance.stub(:errors).and_return('error')
        spree_post :create, {:active_sale => {  }}, valid_session, :method => :post
        assigns(:active_sale).should be_a_new(Spree::ActiveSale)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSale.any_instance.stub(:save).and_return(false)
        Spree::ActiveSale.any_instance.stub(:errors).and_return(['error'])
        spree_post :create, {:active_sale => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested active_sale" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        # Assuming there are no other active_sales in the database, this
        # specifies that the Spree::ActiveSale created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Spree::ActiveSale.any_instance.should_receive(:update_attributes).with(valid_attributes)
        Spree::ActiveSale.any_instance.stub(:errors).and_return(['error'])
        spree_put :update, {:id => active_sale.to_param, :active_sale => valid_attributes}, valid_session
      end

      it "assigns the requested active_sale as @active_sale" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        spree_put :update, {:id => active_sale.to_param, :active_sale => valid_attributes}, valid_session
        assigns(:active_sale).should eq(active_sale)
      end

      it "redirects to the active_sale" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        spree_put :update, {:id => active_sale.to_param, :active_sale => valid_attributes}, valid_session
        response.should redirect_to([:admin, Spree::ActiveSale])
      end
    end

    describe "with invalid params" do
      it "assigns the active_sale as @active_sale" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSale.any_instance.stub(:save).and_return(false)
        Spree::ActiveSale.any_instance.stub(:errors).and_return(['error'])
        spree_put :update, {:id => active_sale.to_param, :active_sale => {  }}, valid_session
        assigns(:active_sale).should eq(active_sale)
      end

      it "re-renders the 'edit' template" do
        active_sale = Spree::ActiveSale.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSale.any_instance.stub(:save).and_return(false)
        Spree::ActiveSale.any_instance.stub(:errors).and_return(['error'])
        spree_put :update, {:id => active_sale.to_param, :active_sale => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested active_sale" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      expect {
        spree_delete :destroy, {:id => active_sale.to_param}, valid_session
      }.to change(Spree::ActiveSale, :count).by(-1)
    end

    it "redirects to the active_sales list" do
      active_sale = Spree::ActiveSale.create! valid_attributes
      spree_delete :destroy, {:id => active_sale.to_param}, valid_session
      response.should redirect_to([:admin, Spree::ActiveSale])
    end
  end

end

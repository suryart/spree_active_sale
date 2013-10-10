require 'spec_helper'

describe Spree::Admin::ActiveSaleEventsController do
  stub_authorization!
  before do
    controller.stub :spree_current_user => FactoryGirl.create(:admin_user)
  end

  let(:product) { create(:product) }
  let(:taxon) { create(:taxon) }

  before(:each) do
    @active_sale = Spree::ActiveSale.create! active_sale_valid_attributes
  end

  # This should return the minimal set of attributes required to create a valid
  # Spree::ActiveSaleEvent. As you add validations to Spree::ActiveSaleEvent, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      "name"=>"Dummy Event", 
      "description"=>"Dummy event description data", 
      "start_date"=> Time.zone.now.strftime("%Y/%m/%d %H:%M:%S %z"), 
      "end_date"=> (Time.zone.now+2.months).strftime("%Y/%m/%d %H:%M:%S %z"), 
      "eventable_type"=> product.class.to_s,
      "eventable_name"=> product.name,
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0",
      "parent_id" => @active_sale.root.id.to_s
    }
  end

  def valid_update_attributes
    valid_attr = valid_attributes
    valid_attr["permalink"] = product.permalink
    valid_attr["eventable_id"] = product.id
    valid_attr["parent_id"] = @active_sale.root.id.to_s
    valid_attr.delete("eventable_name")
    valid_attr
  end

  def active_sale_valid_attributes
    {
      "name"=>"Dummy Sale", 
      "description"=>"Dummy event description data", 
      "start_date"=> Time.zone.now.strftime("%Y/%m/%d %H:%M:%S %z"), 
      "end_date"=> (Time.zone.now+2.months).strftime("%Y/%m/%d %H:%M:%S %z"), 
      "permalink" => taxon.permalink,
      "eventable_type"=> taxon.class.to_s,
      "eventable_id" => taxon.id,
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0"
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::ActiveSaleEventsController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  describe "GET index" do
    it "assigns all active_sale_event_events as @active_sale_event_events" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree_get :index, {:active_sale_id => @active_sale.id}, valid_session
      assigns(:active_sale_events).should eq(@active_sale.active_sale_events(true).to_a)
    end
  end

  describe "GET show" do
    it "assigns the requested active_sale_event as @active_sale_event" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree_get :show, {:id => active_sale_event.to_param, :active_sale_id => @active_sale.id}, valid_session
      assigns(:active_sale_event).should eq(active_sale_event)
    end
  end

  describe "GET new" do
    it "assigns a new active_sale_event as @active_sale_event" do
      spree_get :new, {:active_sale_id => @active_sale.id}, valid_session
      assigns(:active_sale_event).should be_a_new(Spree::ActiveSaleEvent)
    end
  end

  describe "GET edit" do
    it "assigns the requested active_sale_event as @active_sale_event" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree_get :edit, {:id => active_sale_event.to_param, :active_sale_id => @active_sale.id}, valid_session
      assigns(:active_sale_event).should eq(active_sale_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Spree::ActiveSaleEvent" do
        expect {
          spree_get :create, {:active_sale_event => valid_attributes, :active_sale_id => @active_sale.id}, valid_session
        }.to change(Spree::ActiveSaleEvent, :count).by(1)
      end

      it "assigns a newly created active_sale_event as @active_sale_event" do
        spree_post :create, {:active_sale_event => valid_attributes, :active_sale_id => @active_sale.id}, valid_session
        assigns(:active_sale_event).should be_a(Spree::ActiveSaleEvent)
        assigns(:active_sale_event).should be_persisted
      end

      it "redirects to the created active_sale_event" do
        pending "have to fix parent_id concept"
        # spree_post :create, {:active_sale_event => valid_attributes, :active_sale_id => @active_sale.id}, valid_session
        # response.should redirect_to([:admin, @active_sale, Spree::ActiveSaleEvent])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved active_sale_event as @active_sale_event" do
        # Trigger the behavior that occurs when invalid params are submitted
        active_sale_event = @active_sale.active_sale_events.build
        # Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        spree_post :create, {:id => active_sale_event.to_param, :active_sale_event => {  }, :active_sale_id => @active_sale.id}, valid_session
        assigns(:active_sale_event).should be_a_new(Spree::ActiveSaleEvent)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        # Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        active_sale_event = @active_sale.active_sale_events.build
        spree_post :create, {:active_sale_event => {  }, :active_sale_id => @active_sale.id, :parent_id => @active_sale.root.id}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested active_sale_event" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        # Assuming there are no other active_sale_event_events in the database, this
        # specifies that the Spree::ActiveSaleEvent created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Spree::ActiveSaleEvent.any_instance.should_receive(:update_attributes).with(valid_update_attributes)
        Spree::ActiveSaleEvent.any_instance.stub(:errors).and_return(['error'])
        spree_put :update, {:id => active_sale_event.to_param, :active_sale_event => valid_attributes, :active_sale_id => @active_sale.id}, valid_session
      end

      it "assigns the requested active_sale_event as @active_sale_event" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        spree_put :update, {:id => active_sale_event.to_param, :active_sale_event => valid_attributes, :active_sale_id => @active_sale.id}, valid_session
        assigns(:active_sale_event).should eq(active_sale_event)
      end

      it "redirects to the active_sale_event" do
        pending "have to fix parent_id concept"
        # active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        # spree_put :update, {:id => active_sale_event.to_param, :active_sale_event => valid_attributes, :active_sale_id => @active_sale.id}, valid_session
        # response.should redirect_to([:admin, @active_sale, Spree::ActiveSaleEvent])
      end
    end

    describe "with invalid params" do
      it "assigns the active_sale_event as @active_sale_event" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        spree_put :update, {:id => active_sale_event.to_param, :active_sale_event => {  }, :active_sale_id => @active_sale.id}, valid_session
        assigns(:active_sale_event).should eq(active_sale_event)
      end

      it "re-renders the 'edit' template" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        Spree::ActiveSaleEvent.any_instance.stub(:errors).and_return(['error'])
        spree_put :update, {:id => active_sale_event.to_param, :active_sale_event => {  }, :active_sale_id => @active_sale.id, :parent_id => active_sale_event.parent_id}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested active_sale_event" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      expect {
        spree_xhr_get :destroy, {:id => active_sale_event.to_param, :active_sale_id => @active_sale.id}, valid_session
      }.to change(Spree::ActiveSaleEvent, :count).by(-1)
    end

    it "redirects to the active_sale_event_events list" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree_xhr_get :destroy, {:id => active_sale_event.to_param, :active_sale_id => @active_sale.id}, valid_session
      response.code.should eq("200")
    end
  end

end

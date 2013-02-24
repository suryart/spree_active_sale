require 'spec_helper'

describe Spree::Admin::ActiveSaleEventsController do

  # This should return the minimal set of attributes required to create a valid
  # Spree::ActiveSaleEvent. As you add validations to Spree::ActiveSaleEvent, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      "name"=>"Dummy Event", 
      "description"=>"Dummy event description data", 
      "start_date"=>"2013/02/13 19:06:43 +0000", 
      "end_date"=>"2013/02/28 19:06:43 +0000", 
      "eventable_type"=>"Spree::Product", 
      "eventable_name"=>"Ruby on Rails Jr. Spaghetti", 
      "is_active"=>"1", 
      "is_hidden"=>"0", 
      "is_permanent"=>"0",
      "permalink" => "products/ruby-on-rails-jr-spaghetti"
    }
  end

  def active_sale_valid_attributes
    { "name" => "Dummy Sale" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Spree::ActiveSaleEventsController. Be sure to keep this updated too.
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  before(:each) do
    @active_sale = Spree::ActiveSale.create! active_sale_valid_attributes
  end

  describe "GET index" do
    it "assigns all active_sale_event_events as @active_sale_event_events" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree.admin_active_sale_active_sale_events_path :index, {}, valid_session
      assigns(:active_sale_event_events).should eq([active_sale_event])
    end
  end

  describe "GET show" do
    it "assigns the requested active_sale_event as @active_sale_event" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree.admin_active_sale_active_sale_event_path :show, {:id => active_sale_event.to_param}, valid_session
      assigns(:active_sale_event).should eq(active_sale_event)
    end
  end

  describe "GET new" do
    it "assigns a new active_sale_event as @active_sale_event" do
      spree.new_admin_active_sale_active_sale_event_path :new, {}, valid_session
      assigns(:active_sale_event).should be_a_new(Spree::ActiveSaleEvent)
    end
  end

  describe "GET edit" do
    it "assigns the requested active_sale_event as @active_sale_event" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree.edit_admin_active_sale_active_sale_event_path :edit, {:id => active_sale_event.to_param}, valid_session
      assigns(:active_sale_event).should eq(active_sale_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Spree::ActiveSaleEvent" do
        expect {
          spree.admin_active_sale_active_sale_events_path :create, {:active_sale_event => valid_attributes}, valid_session
        }.to change(Spree::ActiveSaleEvent, :count).by(1)
      end

      it "assigns a newly created active_sale_event as @active_sale_event" do
        spree.admin_active_sale_active_sale_events_path :create, {:active_sale_event => valid_attributes}, valid_session
        assigns(:active_sale_event).should be_a(Spree::ActiveSaleEvent)
        assigns(:active_sale_event).should be_persisted
      end

      it "redirects to the created active_sale_event" do
        spree.admin_active_sale_active_sale_events_path :create, {:active_sale_event => valid_attributes}, valid_session
        response.should redirect_to(@active_sale.active_sale_events.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved active_sale_event as @active_sale_event" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        spree.admin_active_sale_active_sale_events_path :create, {:active_sale_event => {  }}, valid_session
        assigns(:active_sale_event).should be_a_new(Spree::ActiveSaleEvent)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        spree.admin_active_sale_active_sale_events_path :create, {:active_sale_event => {  }}, valid_session
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
        Spree::ActiveSaleEvent.any_instance.should_receive(:update_attributes).with(valid_attributes)
        spree.admin_active_sale_active_sale_event_path :update, {:id => active_sale_event.to_param, :active_sale_event => valid_attributes}, valid_session
      end

      it "assigns the requested active_sale_event as @active_sale_event" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        spree.admin_active_sale_active_sale_event_path :update, {:id => active_sale_event.to_param, :active_sale_event => valid_attributes}, valid_session
        assigns(:active_sale_event).should eq(active_sale_event)
      end

      it "redirects to the active_sale_event" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        spree.admin_active_sale_active_sale_event_path :update, {:id => active_sale_event.to_param, :active_sale_event => valid_attributes}, valid_session
        response.should redirect_to(active_sale_event)
      end
    end

    describe "with invalid params" do
      it "assigns the active_sale_event as @active_sale_event" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        spree.admin_active_sale_active_sale_event_path :update, {:id => active_sale_event.to_param, :active_sale_event => {  }}, valid_session
        assigns(:active_sale_event).should eq(active_sale_event)
      end

      it "re-renders the 'edit' template" do
        active_sale_event = @active_sale.active_sale_events.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Spree::ActiveSaleEvent.any_instance.stub(:save).and_return(false)
        spree.admin_active_sale_active_sale_event_path :update, {:id => active_sale_event.to_param, :active_sale_event => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested active_sale_event" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      expect {
        spree.admin_active_sale_active_sale_event_path :destroy, {:id => active_sale_event.to_param}, valid_session
      }.to change(Spree::ActiveSaleEvent, :count).by(-1)
    end

    it "redirects to the active_sale_event_events list" do
      active_sale_event = @active_sale.active_sale_events.create! valid_attributes
      spree.admin_active_sale_active_sale_event_path :destroy, {:id => active_sale_event.to_param}, valid_session
      response.should redirect_to(active_sale_event_events_url)
    end
  end

end

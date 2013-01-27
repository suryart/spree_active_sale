module Spree
  module Admin
    class EventsController < ResourceController
      before_filter :load_data, :except => [:index, :show, :new, :create]
      before_filter :get_eventable, :only => [:create, :update]

      # GET /spree/active_sale/events
      # GET /spree/active_sale/events.json
      def index
        @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        @events = @active_sale.events

        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @spree_active_sale_events }
        end
      end

      # GET /spree/active_sale/events/1
      # GET /spree/active_sale/events/1.json
      def show
        redirect_to( :action => :edit )
      end

      # GET /spree/active_sale/events/new
      # GET /spree/active_sale/events/new.json
      def new
        @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        @event = @active_sale.events.build

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @event }
        end
      end

      # POST /spree/active_sale/events
      # POST /spree/active_sale/events.json
      def create
        @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        @event = @active_sale.events.build(params[:active_sale_event])

        respond_to do |format|
          if @event.save
            format.html { redirect_to admin_active_sale_event_url(@active_sale, @event), notice: 'Event was successfully created.' }
            format.json { render json: @event, status: :created, location: @event }
          else
            format.html { render action: "new" }
            format.json { render json: @event.errors, status: :unprocessable_entity }
          end
        end
      end

      # PUT /spree/active_sale/events/1
      # PUT /spree/active_sale/events/1.json
      def update
        @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        event = @active_sale.events.find(params[:id])

        respond_to do |format|
          if @event.update_attributes(params[:active_sale_event])
            format.html { redirect_to admin_active_sale_event_url(@active_sale, event), notice: 'Event was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @event.errors, status: :unprocessable_entity }
          end
        end
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSale::Event.ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sales_per_page])
        end

        def model_class
          "Spree::ActiveSale::Event".constantize
        end

        def load_data
          @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
          @event = @active_sale.events.find(params[:id])
        end

        def get_eventable
          eventable_type = params[:active_sale_event][:eventable_type]
          eventable = "Spree::#{eventable_type}".constantize.where(:permalink => params[:active_sale_event][:permalink]).first
          return false if eventable.nil?
          params[:active_sale_event][:eventable_type] = eventable.class.name
          params[:active_sale_event][:eventable_id] = eventable.id
        end
    end
  end
end
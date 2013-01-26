module Spree
  module Admin
    class ActiveSale::EventsController < ResourceController
      # GET /spree/active_sale/events
      # GET /spree/active_sale/events.json
      def index
        @spree_active_sale_events = Spree::ActiveSale::Event.all

        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @spree_active_sale_events }
        end
      end

      # GET /spree/active_sale/events/1
      # GET /spree/active_sale/events/1.json
      def show
        @spree_active_sale_event = Spree::ActiveSale::Event.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @spree_active_sale_event }
        end
      end

      # GET /spree/active_sale/events/new
      # GET /spree/active_sale/events/new.json
      def new
        @spree_active_sale_event = Spree::ActiveSale::Event.new

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @spree_active_sale_event }
        end
      end

      # GET /spree/active_sale/events/1/edit
      def edit
        @spree_active_sale_event = Spree::ActiveSale::Event.find(params[:id])
      end

      # POST /spree/active_sale/events
      # POST /spree/active_sale/events.json
      def create
        @spree_active_sale_event = Spree::ActiveSale::Event.new(params[:spree_active_sale_event])

        respond_to do |format|
          if @spree_active_sale_event.save
            format.html { redirect_to @spree_active_sale_event, notice: 'Event was successfully created.' }
            format.json { render json: @spree_active_sale_event, status: :created, location: @spree_active_sale_event }
          else
            format.html { render action: "new" }
            format.json { render json: @spree_active_sale_event.errors, status: :unprocessable_entity }
          end
        end
      end

      # PUT /spree/active_sale/events/1
      # PUT /spree/active_sale/events/1.json
      def update
        @spree_active_sale_event = Spree::ActiveSale::Event.find(params[:id])

        respond_to do |format|
          if @spree_active_sale_event.update_attributes(params[:spree_active_sale_event])
            format.html { redirect_to @spree_active_sale_event, notice: 'Event was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @spree_active_sale_event.errors, status: :unprocessable_entity }
          end
        end
      end

      # DELETE /spree/active_sale/events/1
      # DELETE /spree/active_sale/events/1.json
      def destroy
        @spree_active_sale_event = Spree::ActiveSale::Event.find(params[:id])
        @spree_active_sale_event.destroy

        respond_to do |format|
          format.html { redirect_to spree_active_sale_events_url }
          format.json { head :no_content }
        end
      end
    end
  end
end
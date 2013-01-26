module Spree
  module Admin
    class ActiveSalesController < ResourceController
      # GET /spree/active_sales
      # GET /spree/active_sales.json
      def index
        @search = Spree::ActiveSale.ransack(params[:q])

        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      # GET /spree/active_sales/1
      # GET /spree/active_sales/1.json
      def show
        redirect_to( :action => :edit )
        # @active_sale = Spree::ActiveSale.find(params[:id])

        # respond_to do |format|
        #   format.html # show.html.erb
        #   format.json { render json: [:admin, @active_sale] }
        # end
      end

      # GET /spree/active_sales/new
      # GET /spree/active_sales/new.json
      def new
        @active_sale = Spree::ActiveSale.new

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: [:admin, @active_sale] }
        end
      end

      # GET /spree/active_sales/1/edit
      # def edit
      #   @active_sale = Spree::ActiveSale.find(params[:id])
      # end

      # POST /spree/active_sales
      # POST /spree/active_sales.json
      def create
        @active_sale = Spree::ActiveSale.new(params[:active_sale])

        respond_to do |format|
          if @active_sale.save
            format.html { redirect_to [:admin, @active_sale], notice: I18n.t('spree.active_sale.notice_messages.created') }
            format.json { render json: [:admin, @active_sale], status: :created, location: [:admin, @active_sale] }
          else
            format.html { render action: "new" }
            format.json { render json: [:admin, @active_sale.errors], status: :unprocessable_entity }
          end
        end
      end

      # PUT /spree/active_sales/1
      # PUT /spree/active_sales/1.json
      # def update
      #   @active_sale = Spree::ActiveSale.find(params[:id])

      #   respond_to do |format|
      #     if @active_sale.update_attributes(params[:active_sale])
      #       format.html { redirect_to [:admin, @active_sale], notice: I18n.t('spree.active_sale.notice_messages.updated') }
      #       format.json { head :no_content }
      #     else
      #       format.html { render action: "edit" }
      #       format.json { render json: [:admin, @active_sale.errors], status: :unprocessable_entity }
      #     end
      #   end
      # end

      # DELETE /spree/active_sales/1
      # DELETE /spree/active_sales/1.json
      # TODO override the destory method to set deleted_at value
      # instead of actually deleting the active_sale.
      def destroy
        @active_sale = Spree::ActiveSale.find(params[:id])
        @active_sale.destroy

        flash.notice = I18n.t('spree.active_sale.notice_messages.deleted')

        respond_with(@active_sale) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSale.ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sales_per_page])
        end
    end
  end
end

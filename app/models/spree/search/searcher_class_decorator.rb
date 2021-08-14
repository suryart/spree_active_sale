module Spree
  Config.searcher_class.class_eval do

    def retrieve_sales(*args)
      @sales_scope = get_sale_scope
      if args
        args.each do |additional_scope|
          case additional_scope
            when Hash
              scope_method = additional_scope.keys.first
              scope_values = additional_scope[scope_method]
              @sales_scope = @sales_scope.send(scope_method.to_sym, *scope_values)
            else
              @sales_scope = @sales_scope.send(additional_scope.to_sym)
          end
        end
      end

      curr_page = @properties[:page] || 1
      per_page  = @properties[:per_page] || SpreeActiveSale::Config[:active_sale_events_per_page]
      @sales    = @sales_scope.page(curr_page).per(per_page)
    end

    protected
      def get_base_scope
        sale_scope = Spree::ActiveSaleEvent.available(sale_params)
        unless taxon.blank?
          base_scope = sale_scope.active_products_in_sale_taxon(taxon)
        else
          base_scope = sale_scope.active_products
        end
        base_scope = get_products_conditions_for(base_scope, keywords)
        base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]
        base_scope = add_search_scopes(base_scope)
        base_scope
      end

      def get_sale_scope
        sale_scope = Spree::ActiveSaleEvent.includes(:active_sale, :sale_images).available(sale_params)
        sale_scope = sale_scope.in_taxon(taxon) unless taxon.blank?
        sale_scope = get_sales_conditions_for(sale_scope, keywords) unless keywords.blank?
        sale_scope = add_sale_search_scopes(sale_scope)
        sale_scope = sale_scope.send(sort_by) unless sort_by.blank?
        sale_scope
      end

      def add_sale_search_scopes(sale_scope)
        search.each do |name, scope_attribute|

          scope_name = name.to_sym
          if sale_scope.respond_to?(:search_scurr_pagecopes) && sale_scope.search_scopes.include?(scope_name.to_sym)
            sale_scope = sale_scope.send(scope_name, *scope_attribute)
          else
            sale_scope = sale_scope.merge(Spree::ActiveSaleEvent.includes(:active_sale, :sale_images).search({scope_name => scope_attribute}).result)
          end
        end if search
        sale_scope
      end

      # method should return new scope based on sale_scope
      def get_sales_conditions_for(sale_scope, query)
        unless query.blank?
          sale_scope = sale_scope.like_any([:name, :description], query.split)
        end
        sale_scope
      end

      def sale_params
        { :start_date => @properties[:start_date], :endt_date => @properties[:endt_date], :active => @properties[:active], :hidden => @properties[:hidden] }
      end

      def prepare(params)
        @properties[:start_date] = @properties[:endt_date] = params[:current_time].blank? ? Time.zone.now : DateTime.parse(params[:current_time])
        @properties[:active] = params[:active].blank? ? true : (params[:active] == "true")
        @properties[:hidden] = params[:hidden].blank? ? false : (params[:hidden] == "true")

        # Sort by for sorting sale events by a column ASC or DESC order
        # For example: ascend_by_start_date, descend_by_start_date, ascend_by_end_date, descend_by_end_date, ascend_by_updated_at, descend_by_updated_at, ascend_by_name, descend_by_name
        #@properties[:sort_by] = params[:sort_by] || params['sort_by'] || 'descend_by_start_date'
        @properties[:sort_by] = params[:sort_by] || params['sort_by']

        @properties[:taxon] = params[:taxon].blank? ? nil : Spree::Taxon.find(params[:taxon])
        @properties[:keywords] = params[:keywords]
        @properties[:search] = params[:search]

        per_page = params[:per_page].to_i
        @properties[:per_page] = per_page > 0 ? per_page : Spree::Config[:products_per_page]
        @properties[:page] = (params[:page].to_i <= 0) ? 1 : params[:page].to_i
      end
  end
end

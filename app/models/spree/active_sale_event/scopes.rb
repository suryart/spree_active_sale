module Spree
  module ActiveSaleEvent::Scopes
    def self.prepended(base)
      base.cattr_accessor :search_scopes do
        []
      end

      def base.add_search_scope(name, &block)
        self.singleton_class.send(:define_method, name.to_sym, &block)
        search_scopes << name.to_sym
      end

      def base.simple_scopes
        [
          :ascend_by_start_date,
          :descend_by_start_date,
          :ascend_by_end_date,
          :descend_by_end_date,
          :ascend_by_updated_at,
          :descend_by_updated_at,
          :ascend_by_name,
          :descend_by_name
        ]
      end

      def base.add_simple_scopes(scopes)
        scopes.each do |name|
          parts = name.to_s.match(/(.*)_by_(.*)/)
          order_text = "#{quoted_table_name}.#{parts[2]} #{parts[1] == 'ascend' ?  "ASC" : "DESC"}"
          self.scope(name.to_s, -> { relation.order(order_text) })
        end
      end

      base.add_simple_scopes base.simple_scopes
      base.add_search_scope :start_date_between do |from, to|
        where(ActiveSaleEvent.table_name => { :start_date => from..to })
      end

      base.add_search_scope :end_date_between do |from, to|
        where(ActiveSaleEvent.table_name => { :end_date => from..to })
      end

      base.add_search_scope :active_products do
        Spree::Product.active.includes(:variants_including_master => [:prices, :images]).
          joins([:active_sale_events => :sale_products]).
          merge(Spree::ActiveSaleEvent.available).
          order("spree_sale_products.position ASC")
      end

      base.add_search_scope :active_products_in_sale_taxon do |taxon|
        Spree::Product.active.includes(:variants_including_master => [:prices, :images]).
          joins([:active_sale_events => :sale_products]).
          merge(Spree::ActiveSaleEvent.available.in_sale_taxon(taxon)).
          order("spree_sale_products.position ASC")
      end

      base.add_search_scope :active_taxons do
        Spree::Taxon.
          joins([:active_sale_events]).
          merge(Spree::ActiveSaleEvent.available).uniq
      end
      # This scope selects sales in taxon AND all its descendants
      # If you need sales only within one taxon use
      #
      #   Spree::ActiveSaleEvent.taxons_id_eq(x)
      #
      # If you're using count on the result of this scope, you must use the
      # `:distinct` option as well:
      #
      #   Spree::ActiveSaleEvent.in_taxon(taxon).count(:distinct => true)
      #
      # This is so that the count query is distinct'd:
      #
      #   SELECT COUNT(DISTINCT "spree_active_sale_events"."id") ...
      #
      #   vs.
      #
      #   SELECT COUNT(*) ...
      base.add_search_scope :in_taxon do |taxon|
        if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
          scope = select("DISTINCT ON (spree_active_sale_events.id) spree_active_sale_events.*")
        else
          scope = select("DISTINCT(spree_active_sale_events.id), spree_active_sale_events.*")
        end

        scope.joins(:taxons).
          where(Taxon.table_name => { :id => taxon.self_and_descendants.map(&:id) })
      end

      base.add_search_scope :in_sale_taxon do |taxon|
        joins([:active_sale_events => :taxons]).
          where(Taxon.table_name => { :id => taxon.self_and_descendants.map(&:id) })
      end

      # This scope selects sales in all taxons AND all its descendants
      # If you need sales only within one taxon use
      #
      # Spree::ActiveSaleEvent.taxons_id_eq([x,y])
      base.add_search_scope :in_taxons do |*taxons|
        taxons = get_taxons(taxons)
        taxons.first ? prepare_taxon_conditions(taxons) : scoped
      end

      # a scope that finds all sales having property specified by name, object or id
      base.add_search_scope :with_property do |property|
        properties = Property.table_name
        conditions = case property
                     when String   then { "#{properties}.name" => property }
                     when Property then { "#{properties}.id" => property.id }
                     else               { "#{properties}.id" => property.to_i }
                     end

        joins(:properties).where(conditions)
      end

      # a simple test for sale event with a certain property-value pairing
      # note that it can test for properties with NULL values, but not for absent values
      base.add_search_scope :with_property_value do |property, value|
        properties = Spree::Property.table_name
        conditions = case property
                     when String   then ["#{properties}.name = ?", property]
                     when Property then ["#{properties}.id = ?", property.id]
                     else               ["#{properties}.id = ?", property.to_i]
                     end
        conditions = ["#{SaleProperty.table_name}.value = ? AND #{conditions[0]}", value, conditions[1]]

        joins(:properties).where(conditions)
      end

      # Finds all sales that have a name containing the given words.
      base.add_search_scope :in_name do |words|
        like_any([:name], prepare_words(words))
      end

      # Finds all sales that have a name or meta_keywords containing the given words.
      base.add_search_scope :in_name_or_keywords do |words|
        like_any([:name, :meta_keywords], prepare_words(words))
      end

      # Finds all sales that have a name, description, meta_description or meta_keywords containing the given keywords.
      base.add_search_scope :in_name_or_description do |words|
        like_any([:name, :description, :meta_description, :meta_keywords], prepare_words(words))
      end

      # Finds all sales that have the ids matching the given collection of ids.
      # Alternatively, you could use find(collection_of_ids), but that would raise an exception if one sale event couldn't be found
      base.add_search_scope :with_ids do |*ids|
        where(:id => ids)
      end

      base.add_search_scope :not_deleted do
        where("#{quoted_table_name}.deleted_at IS NULL or #{quoted_table_name}.deleted_at >= ?", zone_time)
      end

      # This method can acts as a time machine for sales
      # For example: All sales started 10 days ago and will end after 5 days -
      # Spree::ActiveSaleEvent.live(:start_date => 10.days.ago, :end_date => 5.days.from_now)
      base.add_search_scope :live do |*args|
        arg = args.try(:first).try(:present?) ? args.first : {}
        start_date, end_date = arg[:start_date], arg[:end_date]
        start_date = start_date.kind_of?(ActiveSupport::TimeWithZone) ? start_date : zone_time
        end_date = end_date.kind_of?(ActiveSupport::TimeWithZone) ? end_date : zone_time
        where("((#{quoted_table_name}.start_date <= :start_date AND #{quoted_table_name}.end_date >= :end_date) OR #{quoted_table_name}.is_permanent = :is_permanent)", { :start_date => start_date, :end_date => end_date, :is_permanent => true })
      end

      base.add_search_scope :active do |*args|
        where(:is_active => valid_argument(args))
      end

      base.add_search_scope :hidden do |*args|
        where(:is_hidden => valid_argument(args))
      end

      base.add_search_scope :live_active do |*args|
        args = prepare_argument(args)
        live(args.first).active(valid_argument([args.first[:active]]))
      end

      base.add_search_scope :live_active_and_hidden do |*args|
        args = prepare_argument(args)
        live_active(args).hidden(valid_argument([args.first[:hidden]]))
      end

      base.add_search_scope :upcoming_events do |*args|
        where("start_date > :start_date", { :start_date => zone_time })
      end

      base.add_search_scope :past_events do |*args|
        where("end_date < :end_date", { :end_date => zone_time })
      end

      base.add_search_scope :starting_today do |*args|
        where(:start_date => zone_day_duration)
      end

      base.add_search_scope :ending_today do |*args|
        where(:end_date => zone_day_duration)
      end

      base.add_search_scope :available do |*args|
        args = prepare_argument(args)
        scope = not_deleted.live_active(args)
        unless args.first[:hidden].blank?
          scope = scope.hidden(args.first[:hidden])
        end
        scope
      end

      base.add_search_scope :taxons_name_eq do |name|
        group("quoted_table_name.id").joins(:taxons).where(Taxon.arel_table[:name].eq(name))
      end

      def base.group_by_sales_id
        if (ActiveRecord::Base.connection.adapter_name == 'PostgreSQL')
          # Need to check, otherwise `column_names` will fail
          if table_exists?
            group(column_names.map { |col_name| "#{quoted_table_name}.#{col_name}"})
          end
        else
          group("#{quoted_table_name}.id")
        end
      end

      def base.valid_argument args
        (args.first == nil || args.first == true)
      end

      def base.prepare_argument args
        arg = args.try(:first)
        [nil, true, false].include?(arg) || arg.try(:blank?) ? [{}] : args.flatten
      end

      def base.zone_time
        Time.zone.now
      end

      def base.zone_day_duration
        zone_time.beginning_of_day..zone_time.end_of_day
      end

      # specifically avoid having an order for taxon search (conflicts with main order)
      def base.prepare_taxon_conditions(taxons)
        ids = taxons.map { |taxon| taxon.self_and_descendants.pluck(:id) }.flatten.uniq
        joins(:taxons).where("#{Taxon.table_name}.id" => ids)
      end

      # Produce an array of keywords for use in scopes.
      # Always return array with at least an empty string to avoid SQL errors
      def base.prepare_words(words)
        return [''] if words.blank?
        a = words.split(/[,\s]/).map(&:strip)
        a.any? ? a : ['']
      end

      def base.get_taxons(*ids_or_records_or_names)
        taxons = Taxon.table_name
        ids_or_records_or_names.flatten.map { |t|
          case t
          when Integer then Taxon.find_by_id(t)
          when ActiveRecord::Base then t
          when String
            Taxon.find_by_name(t) ||
              Taxon.where("#{taxons}.permalink LIKE ? OR #{taxons}.permalink = ?", "%/#{t}/", "#{t}/").first
          end
        }.compact.flatten.uniq
      end
    end
  end
end

Spree::ActiveSaleEvent.prepend(Spree::ActiveSaleEvent::Scopes)

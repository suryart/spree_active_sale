module Spree
  TaxonsController.class_eval do

    def show
      @taxon = Spree::Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
      @products = @searcher.retrieve_products
      @taxonomies = Spree::Taxonomy.includes(root: :children)

      respond_with(@taxon)
    end
  end
end
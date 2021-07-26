# Gets updates from a product on Pluggto and updates the product on Spree
module SpreePluggto
  class UpdateSpreeProduct
    attr_reader   :pluggto_product
    attr_accessor :spree_product

    def initialize(pluggto_id)
      @pluggto_product = SpreePluggto::Api::Product.find(pluggto_id)
      @spree_product   = ::Spree::Product.find_by!(pluggto_id: pluggto_id)
    end

    def call
      # Logic here to define what we want to update on Spree when PluggTo say a product was updated
      # Only stock?
    end
  end
end

# When a product is deleted on Plugg, we remove the pluggto_id reference on Spree
module SpreePluggto
  class DeleteSpreeProductReference
    attr_accessor :spree_product

    def initialize(sku)
      @spree_product = ::Spree::Product.find_by!(sku: sku)
    end

    def call
      spree_product.update_columns(pluggto_id: nil)
    end
  end
end

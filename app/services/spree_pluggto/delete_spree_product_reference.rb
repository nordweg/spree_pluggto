# When a product is deleted on Plugg, we remove the pluggto_id reference on Spree
module SpreePluggto
  class DeleteSpreeProductReference
    attr_accessor :spree_product

    def initialize(sku)
      variant = ::Spree::Variant.find_by!(sku: sku)
      @spree_product = variant.product
    end

    def call
      spree_product.update_columns(pluggto_id: nil)
    end
  end
end

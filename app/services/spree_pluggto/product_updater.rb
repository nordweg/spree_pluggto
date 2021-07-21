# Gets updates from a product on Pluggto and updates the product on Spree
module SpreePluggto
  class ProductUpdater
    attr_reader :pluggto_id

    def initialize(pluggto_id)
      @pluggto_id = pluggto_id
    end

    def call
      pluggto_product = SpreePluggto::Product.find(pluggto_id)
      spree_product   = Spree::Product.find_by(pluggto_id: pluggto_id)
    end
  end
end

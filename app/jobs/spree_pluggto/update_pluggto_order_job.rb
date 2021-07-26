module SpreePluggto
  class UpdatePluggtoOrderJob < ActiveJob::Base
    def perform(order_number)
    spree_order = ::Spree::Order.find_by!(number: order_number)
     SpreePluggto::Api::Order.update(spree_order)
    end
  end
end

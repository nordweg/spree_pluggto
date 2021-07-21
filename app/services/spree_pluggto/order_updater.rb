# Gets updates from an order on Pluggto and updates the order on Spree
module SpreePluggto::Api
  class OrderUpdater
    attr_reader :pluggto_id

    def initialize(pluggto_id)
      @pluggto_id = pluggto_id
    end

    def call
      pluggto_order = SpreePluggto::Order.find(pluggto_id)
      spree_order   = Spree::Order.find_by!(pluggto_id: pluggto_id)

      case pluggto_status
      when 'pending' # Order is not paid
        # Do nothing
      when 'partial_payment' # Order is paid, but freight not
        update_payments
      when 'approved' # Order is paid and approved
        update_payments
      when 'shipped' # MarketPlace accept the shipping information and informed de customer
        update_shipments
      when 'canceled' # The order was canceled
        spree_order.cancel!
      end
    end

    def spree_state(pluggto_status)
      case pluggto_status
      when 'pending' # Order is not paid
        # Do nothing
      when 'partial_payment' # Order is paid, but freight not
        update_payments
      when 'approved' # Order is paid and approved
        update_payments
      when 'shipped' # MarketPlace accept the shipping information and informed de customer
        update_shipments
      when 'canceled' # The order was canceled
        spree_order.cancel!
      end
    end
  end
end

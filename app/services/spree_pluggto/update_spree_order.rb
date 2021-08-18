# Gets updates from an order on Pluggto and updates the order on Spree
module SpreePluggto
  class UpdateSpreeOrder
    attr_reader   :pluggto_order
    attr_accessor :spree_order

    def initialize(pluggto_id)
      @pluggto_order = ::SpreePluggto::Api::Order.find(pluggto_id)
      @spree_order   = ::Spree::Order.find_by!(pluggto_id: pluggto_id)
    end

    def call
      case pluggto_order["status"]
      when 'pending'
        update_payments
      when 'approved'
        update_payments
        set_as_paid
        if !spree_order.shipped?
          set_as_ready
          spree_order.fulfill!
        end
      when 'canceled'
        spree_order.update_columns(state: 'canceled')
      end
    end

    private

    def update_payments
      pluggto_order["payments"].each do |pluggto_payment|
        spree_order.payments.find_or_create_by(
          payment_method: ::Spree::PaymentMethod.find_by(type:"Spree::PaymentMethod::StoreCredit"), # Not ideal - we should define a specific payment method referring to PluggTo
          amount: pluggto_payment["payment_total"],
          installments: pluggto_payment["payment_installments"],
          state: "completed"
        )
      end
    end

    def set_as_ready
      spree_order.update_columns(shipment_state: 'ready')
    end

    def set_as_paid
      spree_order.update_columns(payment_state: 'paid')
    end

  end
end

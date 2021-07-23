# Gets updates from an order on Pluggto and updates the order on Spree
module SpreePluggto
  class UpdateSpreeOrder
    attr_reader   :pluggto_order
    attr_accessor :spree_order

    def initialize(pluggto_id)
      @pluggto_order = SpreePluggto::Api::Order.find(pluggto_id)
      @spree_order   = Spree::Order.find_by!(pluggto_id: pluggto_id)
    end

    def call
      case pluggto_order["status"]
      when 'partial_payment', 'approved'
        update_payments
      when 'canceled'
        spree_order.cancel!
      end
    end

    def update_payments
      pluggto_order["payments"].each do |pluggto_payment|
        spree_order.payments.find_or_create_by(
          payment_method: Spree::PaymentMethod.find_by(type:"Spree::PaymentMethod::StoreCredit"), # Not ideal - we should define a specific payment method referring to PluggTo
          amount: pluggto_payment["payment_total"],
          installments: pluggto_payment["payment_installments"],
          state: "completed"
        )
      end
    end

  end
end

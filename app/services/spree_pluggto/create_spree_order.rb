# Creates on Spree e new order after it was created on Pluggto
module SpreePluggto
  class CreateSpreeOrder
    attr_reader :pluggto_id

    def initialize(pluggto_id)
      @pluggto_id = pluggto_id
    end

    def call
      # Skip creation if the order was already created on Spree
      return if ::Spree::Order.find_by(pluggto_id: pluggto_id)

      # Get info Plugg
      pluggto_order = ::SpreePluggto::Api::Order.find(pluggto_id)

      # Create the order on Spree
      spree_order = ::Spree::Order.create(
        channel: "pluggto",
        pluggto_id: pluggto_order["id"],
        user: ::Spree::User.find_by(email: pluggto_order["receiver_email"]),
        email: pluggto_order["receiver_email"],
        cpf: pluggto_order["receiver_cpf"] || pluggto_order["payer_cpf"],
      )

      # Add line items
      pluggto_order["items"].each do |pluggto_item|
        spree_order.line_items.new(
          variant: ::Spree::Variant.find_by(sku: pluggto_item["sku"]),
          quantity: pluggto_item["quantity"],
          price: pluggto_item["price"]
        )
      end

      # Go to Addres
      spree_order.next

      # Add ship_address
      spree_order.ship_address = ::Spree::Address.new(
        firstname: pluggto_order["receiver_name"],
        lastname: pluggto_order["receiver_lastname"],
        address1: pluggto_order["receiver_address"],
        address2: "#{pluggto_order["receiver_address_complement"]} - #{pluggto_order["receiver_address_reference"]}",
        neighborhood: pluggto_order["receiver_neighborhood"],
        street_number: pluggto_order["receiver_address_number"],
        city: pluggto_order["receiver_city"],
        zipcode: pluggto_order["receiver_zipcode"],
        phone: "(#{pluggto_order['receiver_phone_area']}) #{pluggto_order['receiver_phone']}",
        state_name: pluggto_order["receiver_state"],
        state: ::Spree::State.find_by(abbr: pluggto_order["receiver_state"]),
        alternative_phone: "(#{pluggto_order['receiver_phone2_area']}) #{pluggto_order['receiver_phone2']}",
        country: ::Spree::Country.find_by(iso: "BR")
      )

      # Add bill_address
      spree_order.bill_address = ::Spree::Address.new(
        firstname: pluggto_order["payer_name"],
        lastname: pluggto_order["payer_lastname"],
        address1: pluggto_order["payer_address"],
        address2: "#{pluggto_order["payer_address_complement"]} - #{pluggto_order["payer_address_reference"]}",
        neighborhood: pluggto_order["payer_neighborhood"],
        street_number: pluggto_order["payer_address_number"],
        city: pluggto_order["payer_city"],
        zipcode: pluggto_order["payer_zipcode"],
        phone: "(#{pluggto_order['payer_phone_area']}) #{pluggto_order['payer_phone']}",
        state_name: pluggto_order["payer_state"],
        state: ::Spree::State.find_by(abbr: pluggto_order["payer_state"]),
        alternative_phone: "(#{pluggto_order['payer_phone2_area']}) #{pluggto_order['payer_phone2']}",
        country: ::Spree::Country.find_by(iso: "BR")
      )

      # Go to delivery
      spree_order.next!

      # Go to payment
      spree_order.next!

      # By calling 'next' the first shipping option was selected,
      # we need to set it up according to what we received from Pluggto
      spree_order.shipments.first.update_columns(
        cost: pluggto_order["shipping"],
        pluggto_id: pluggto_order.dig("shipments",0,"id")
      )
      spree_order.update_columns(
        shipment_total: pluggto_order["shipping"]
      )

      # Add discounts
      if pluggto_order["discount"].present? && pluggto_order["discount"] > 0
        spree_order.adjustments.create(
          order: spree_order,
          label: "Desconto via Plugg.to",
          amount: pluggto_order["discount"] * -1,
          eligible: true
        )
      end

      # Update the total after discounts
      spree_order.update_totals

      # Add payments
      pluggto_order["payments"].each do |pluggto_payment|
        spree_order.payments.create(
          payment_method: ::Spree::PaymentMethod.find_by(type:"Spree::PaymentMethod::StoreCredit"), # Not ideal - we should define a specific payment method referring to PluggTo
          installments: pluggto_payment["payment_installments"],
          amount: pluggto_payment["payment_total"],
          state: "completed"
        )
      end

      # Completes the order
      # The "Pending" on Pluggto is NOT "Paid", even if it has payments
      # We should force the payments status according to the plugg_order status
      spree_order.update_columns(
        state: 'complete',
        completed_at: DateTime.now,
        payment_state: pluggto_order["status"] == 'approved' ? 'paid' : 'balance_due'
      )
      spree_order.update_with_updater! if spree_order.paid?
    end
  end
end

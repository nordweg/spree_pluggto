# Creates on Spree e new order after it was created on Pluggto
module SpreePluggto
  class CreateSpreeOrder
    attr_reader :pluggto_id

    def initialize(pluggto_id)
      @pluggto_id = pluggto_id
    end

    def call
      pluggto_order = SpreePluggto::Api::Order.find(pluggto_id)

      # Create the order on Spree
      spree_order = ::Spree::Order.create(
        channel: "pluggto",
        pluggto_id: pluggto_id,
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

      # By calling 'next' the first shipping option was selected, we need to set it up according to what we received from Pluggto
      spree_order.update_columns(
        shipment_total: pluggto_order["shipping"]
      )
      spree_order.shipments.first.update_columns(
        cost: pluggto_order["shipping"]
      )

      # Add payments
      spree_order.payment_state = 'paid'
      pluggto_order["payments"].each do |pluggto_payment|
        spree_order.payments.create(
          payment_method: ::Spree::PaymentMethod.find_by(type:"Spree::PaymentMethod::StoreCredit"), # Not ideal - we should define a specific payment method referring to PluggTo
          installments: pluggto_payment["payment_installments"],
          amount: pluggto_payment["payment_total"],
          state: "completed"
        )
      end

      # Complete the order
      spree_order.next
      spree_order.update_columns(state: 'complete')
    end
  end
end

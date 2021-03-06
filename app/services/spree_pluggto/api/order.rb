module SpreePluggto::Api
  class Order
    class << self

      def find(pluggto_id)
        response = ::SpreePluggto::Api::Request.new.get("/orders/#{pluggto_id}")
        response["Order"]
      end

      def update(spree_order)
        response = ::SpreePluggto::Api::Request.new.put("/orders/#{spree_order.pluggto_id}", params(spree_order).to_json)
      end

      private

      def pluggto_status(spree_order)
        return 'canceled' if spree_order.canceled?
        return 'shipping_informed' if spree_order.shipped?
        return 'approved' if spree_order.shipment_state == 'ready'
        return 'partial_payment' if spree_order.payment_state == 'credit_owed'
        return 'pending'
      end

      def phone_area(number)
        ddd_regex = /\((?<DDD>\d\d)\)/
        ddd_regex.match(number)["DDD"]
      end

      def phone_without_area(number)
        number.sub(/\(..\)/, '').strip
      end

      def params(spree_order)
        {
          "status": pluggto_status(spree_order),
          "subtotal": spree_order.amount,
          "total": spree_order.total,
          "total_paid": spree_order.payment_total.to_s,
          "shipping": spree_order.shipment_total,
          "discount": spree_order.adjustment_total,
          "external": spree_order.number,

          "receiver_email": spree_order.email,
          "receiver_name": spree_order.ship_address.firstname,
          "receiver_lastname": spree_order.ship_address.lastname,
          "receiver_address": spree_order.ship_address.address1,
          "receiver_address_number": spree_order.ship_address.street_number,
          "receiver_address_complement": spree_order.ship_address.address2,
          "receiver_city": spree_order.ship_address.city,
          "receiver_neighborhood": spree_order.ship_address.neighborhood,
          "receiver_state": spree_order.ship_address.state.abbr,
          "receiver_zipcode": spree_order.ship_address.zipcode,
          "receiver_phone": phone_without_area(spree_order.ship_address.phone),
          "receiver_phone_area": phone_area(spree_order.ship_address.phone),

          "payer_email": spree_order.email,
          "payer_name": spree_order.bill_address.firstname,
          "payer_lastname": spree_order.bill_address.lastname,
          "payer_address": spree_order.bill_address.address1,
          "payer_address_number": spree_order.bill_address.street_number,
          "payer_address_complement": spree_order.bill_address.address2,
          "payer_city": spree_order.bill_address.city,
          "payer_neighborhood": spree_order.bill_address.neighborhood,
          "payer_state": spree_order.bill_address.state.abbr,
          "payer_zipcode": spree_order.bill_address.zipcode,
          "payer_phone": phone_without_area(spree_order.bill_address.phone),
          "payer_phone_area": phone_area(spree_order.bill_address.phone),
          "payer_cpf": spree_order.cpf,

          "shipments": spree_order.shipments.map { |shipment|
            {
              "id": shipment.pluggto_id,
              "estimate_delivery_date": (shipment.expected_delivery_date if shipment.shipped?),
              "nfe_date": (shipment.shipped_at.to_date if shipment.shipped?),
              "nfe_key": (shipment.get_invoice_key if shipment.shipped?),
              "track_url": (shipment.tracking_url_with_code if shipment.shipped?),
              "nfe_link": (shipment.get_invoice_pdf if shipment.shipped?),
              "external": shipment.number,
              "shipping_company": shipment.shipping_method.name,
              "shipping_method": shipment.shipping_method.name,
              "track_code": shipment.tracking,
              "date_shipped": shipment.shipped_at&.to_date,
              "nfe_number": shipment.nf_number&.split("/")&.first,
              "nfe_serie": shipment.nf_number&.split("/")&.last,
              "shipping_items": shipment.line_items.map { |line_item|
                {
                  "sku": line_item.sku,
                  "quantity": line_item.quantity
                }
              }
            }
          },

          "items": spree_order.line_items.map { |line_item|
            {
              "quantity": line_item.quantity,
              "sku": line_item.sku,
              "price": line_item.price,
              "total": line_item.total,
              "name": line_item.name,
              "variation": {
                "sku": line_item.sku
              },
            }
          }

        }.compact
      end

    end
  end
end

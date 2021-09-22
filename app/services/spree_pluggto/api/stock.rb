module SpreePluggto::Api
  class Stock
    class << self
      def update(variant)
        ::SpreePluggto::Api::Request.new.put("/skus/#{variant.sku}/stock", params(variant).to_json)
      end

      def params(variant)
        {
          "action": "update",
          "quantity": variant.total_on_hand.finite? ? variant.total_on_hand : 99,
          "sku": variant.sku
        }
      end
    end
  end
end

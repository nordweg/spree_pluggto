module SpreePluggto
  class Api
    def find_product(spree_product)
      SpreePluggto::Request.new.get("/products/{pluggto_product_id}")
    end

    def upset_product(spree_product)
      SpreePluggto::Request.new.put("/skus/#{product.sku}", product.pluggto_product.to_json)
    end

    def upsert_variant(spree_variant)
      SpreePluggto::Request.new.put("/skus/#{spree_variant.sku}", body)
    end
  end
end

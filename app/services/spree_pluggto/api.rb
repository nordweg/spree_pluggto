module SpreePluggto
  class Api
    def find_product(spree_product)
      SpreePluggto::Request.get("/products/{pluggto_product_id}")
    end

    def upset_product(spree_product)
      SpreePluggto::Request.put("/skus/#{spree_product.sku}")
    end

    def upsert_variant(spree_variant)
      SpreePluggto::Request.put("/skus/#{spree_variant.sku}", body)
    end
  end
end

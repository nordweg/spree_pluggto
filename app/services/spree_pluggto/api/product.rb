module SpreePluggto::Api
  class Product
    class << self

      def find(pluggto_id)
        response = ::SpreePluggto::Api::Request.new.get("/products/#{pluggto_id}")
        response["Product"]
      end

      # UPSERT => Updates the record if it exists, inserts if it is a new record
      def upsert(spree_product)
        response = ::SpreePluggto::Api::Request.new.put("/skus/#{spree_product.sku}", params(spree_product).to_json)
        spree_product.update_columns(pluggto_id: response.dig("Product","id"))
      end

      private

      def params(product)
        {
          "sku": product.sku,
          "name": product.name,
          "special_price": product.on_sale? ? product.sale_price : product.price,
          "price": product.price,
          "description": product.description,
          "brand": product.brand,
          "warranty_time": product.try(:months_of_warranty),
          "warranty_message": product.lifetime_warranty? ? "Garantia vitalícia" : "",
          "link": "#{::Rails.application.routes.url_helpers.spree_url}products/#{product.slug}",
          "categories": product.taxons.map { |taxon| {"name": taxon.name } },
          "handling_time": ::Spree::Config.try(:handling_time),
          "ean_not_mandatory": true,
          "dimension": {
            "length": product.depth,
            "width": product.width,
            "height": product.height,
            "weight": product.weight
          },
          "photos": product.images.map { |image|
            {
              "url": image.attachment.url(:big),
              "name": product.name,
              "title": product.name,
              "order": image.position,
              "external": image.attachment.url(:big)
            }
          },
          "variations": product.variants.map { |variant|
            {
              "sku": variant.sku,
              "name": variant.name,
              "quantity": variant.total_on_hand.finite? ? variant.total_on_hand : 99,
              "special_price": variant.product.on_sale? ? variant.product.sale_price : variant.price,
              "price": variant.price,
              "ean_not_mandatory": true,
              "attributes": variant.option_values.map { |option_value|
                {
                  "code": option_value.option_type.name,
                  "label": option_value.option_type.name,
                  "value": { "code": option_value.name, "label": option_value.name }
                }
              },
              "photos": variant.images.map { |image|
                {
                  "url": image.attachment.url(:big),
                  "name": variant.name,
                  "title": variant.name,
                  "order": image.position,
                  "external": image.attachment.url(:big)
                }
              }
            }
          }
        }
      end

    end
  end
end

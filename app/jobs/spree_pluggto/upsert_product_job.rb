module SpreePluggto
  class UpsertProductJob < ApplicationJob
    # UPSERT => Updates the record if it exists, inserts if it is new
    def perform(product_id)
      product = Spree::Product.find!(product_id)
      SpreePluggto::Product.upsert(product)
    end
  end
end

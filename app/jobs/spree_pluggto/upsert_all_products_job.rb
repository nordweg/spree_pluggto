module SpreePluggto
  class UpsertAllProductsJob < ActiveJob::Base
    def perform
     ::Spree::Product.active.each do |product|
       UpsertProductJob.perform_now(product.id)
      end
    end
  end
end

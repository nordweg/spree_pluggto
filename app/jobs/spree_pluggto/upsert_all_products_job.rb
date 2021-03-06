module SpreePluggto
  class UpsertAllProductsJob < ActiveJob::Base
    def perform
      ::Spree::Product.active.where(sync_with_pluggto: true).each do |product|
        ::SpreePluggto::UpsertProductJob.perform_now(product.id)
      end
    end
  end
end

module SpreePluggto
  class UpdateStockJob < ActiveJob::Base
    def perform(variant_id)
      variant = ::Spree::Variant.find(variant_id)
      ::SpreePluggto::Api::Stock.update(variant)
    end
  end
end

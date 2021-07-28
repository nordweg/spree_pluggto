module SpreePluggto
  class SkuDeletedJob < ActiveJob::Base
    def perform(sku)
     ::SpreePluggto::DeleteSpreeProductReference.new(sku).call
    end
  end
end

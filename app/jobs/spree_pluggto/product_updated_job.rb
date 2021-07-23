module SpreePluggto
  class ProductUpdatedJob < ActiveJob::Base
    def perform(pluggto_id)
     SpreePluggto::UpdateSpreeProduct.new(pluggto_id).call
    end
  end
end

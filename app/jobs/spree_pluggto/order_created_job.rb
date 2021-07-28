module SpreePluggto
  class OrderCreatedJob < ActiveJob::Base
    def perform(pluggto_id)
     ::SpreePluggto::CreateSpreeOrder.new(pluggto_id).call
    end
  end
end

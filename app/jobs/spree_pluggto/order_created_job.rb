module SpreePluggto
  class OrderCreatedJob < ActiveJob::Base
    def perform(order_number)
     SpreePluggto::CreateSpreeOrder.new(pluggto_id).call
    end
  end
end

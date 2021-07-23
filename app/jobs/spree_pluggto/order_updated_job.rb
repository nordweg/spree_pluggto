module SpreePluggto
  class OrderUpdatedJob < ActiveJob::Base
    def perform(order_number)
     SpreePluggto::UpdateSpreeOrder.new(pluggto_id).call
    end
  end
end

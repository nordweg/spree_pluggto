module SpreePluggto
  class OrderUpdatedJob < ActiveJob::Base
    def perform(pluggto_id)
     ::SpreePluggto::UpdateSpreeOrder.new(pluggto_id).call
    end
  end
end

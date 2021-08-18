module SpreePluggto
  class OrderCreatedJob < ActiveJob::Base


    # sidekiq_retries_exhausted do |msg, ex|
    #   message = "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    #   ::SpreePluggto::SendIntegrationErrors.new(msg['args']).call(message)
    # end
    # https://edgeguides.rubyonrails.org/active_job_basics.html#exceptions
    # https://stackoverflow.com/questions/32193144/in-activejob-how-to-catch-any-exception
    # https://github.com/mperham/sidekiq/issues/4496#issuecomment-600714253
    # https://stackoverflow.com/questions/29085458/how-to-access-perform-parameters-in-activejob-rescue
    rescue_from(StandardError) do |exception|
      puts "--- Problem creating plugg_to order #{arguments} ---"
      puts exception
      ::SpreePluggto::SendIntegrationErrors.new(arguments).call(exception)
    end

    def perform(pluggto_id)
      ::SpreePluggto::CreateSpreeOrder.new(pluggto_id).call
    end
  end
end

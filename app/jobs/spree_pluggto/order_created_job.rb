module SpreePluggto
  class OrderCreatedJob < ActiveJob::Base


    # sidekiq_retries_exhausted do |msg, ex|
    #   message = "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    #   ::SpreePluggto::SendIntegrationErrors.new(msg['args']).call(message)
    # end
    rescue_from(StandardError) do |exception|
      puts "arguments"
      puts arguments
      puts "exception"
      puts exception
      pluggto_id = arguments[0]
      ::SpreePluggto::SendIntegrationErrors.new(pluggto_id).call(exception)
    end

    def perform(pluggto_id)
      ::SpreePluggto::CreateSpreeOrder.new(pluggto_id).call
    end
  end
end

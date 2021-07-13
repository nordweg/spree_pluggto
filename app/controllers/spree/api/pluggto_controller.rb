module Spree
  module Api
    class PluggtoController < Spree::Api::BaseController
      skip_before_action :authenticate_user

      def notifications
        puts "Received some data!"
        puts "Request"
        p request
        puts "Request Body"
        p request.body
        puts "Request Body Read"
        p request.body.read
      end 
    end
  end
end

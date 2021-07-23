module Spree
  module Api
    module V1
      class PluggtoController < Spree::Api::BaseController
        skip_before_action :authenticate_user

        # The post will be send in the following format:
        # {"type":"PRODUCTS/SKUS/ORDERS","id":"PLUGGTO_ID","action":"UPDATEORCREATE","user":1120, "changes" : {"status" : false,"stock" : false,"price":false }}
        #
        # Example:
        # { "user" : 129, "id" : "5b9169c309eacd415056aa3a", "changes" : { "status" : false, "stock" : false, "price" : false }, "type" : "products", "action" : "updated" }
        # Example notification body received from

        def notifications
          notification = request.body.read
          puts "Notification here:"
          p notification
          puts "Params"
          p params
          SpreePluggto::NotificationHandler.new(notification).call
          render status: :ok
        end
      end
    end
  end
end

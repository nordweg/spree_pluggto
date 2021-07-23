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
          puts "Notification received from PluggTo:"
          p params[:pluggto]
          SpreePluggto::NotificationHandler.new(params[:pluggto]).call
          render head: :ok
        end

      end
    end
  end
end

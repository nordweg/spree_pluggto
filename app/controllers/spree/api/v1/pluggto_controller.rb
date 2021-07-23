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

        def notifications
          puts "Notification received from PluggTo: #{notification_params}"
          service_class = "spree_pluggto/#{type.singularize}_#{action}_job".camelize
          puts "Service: #{service_class}"
          service_class.constantize.perform_later(notification_params[:id])
          render head: :ok
        end

        private

        def notification_params
          params.require(:pluggto).permit!
        end

      end
    end
  end
end

module Spree
  module Api
    module V1
      class PluggtoController < Spree::Api::BaseController
        skip_before_action :authenticate_user

        # request.body = {
        #   "user": 129,
        #   "id": "5b9169c309eacd415056aa3a",
        # "changes": {
        #   "status": true,
        #   "stock": false,
        #   "price": false
        # },
        #   "type": "products",
        #   "action": "updated"
        # }

        def notifications
          SpreePluggto::NotificationHandler.new(request.body).call
          render status: :ok
        end
      end
    end
  end
end

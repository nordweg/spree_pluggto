module Spree
  module Admin
    class PluggtoSettingsController < Spree::Admin::BaseController
      before_action :set_pluggto_settings

      # Heavily inspired by SpreeMailchimpEcommerce
      # https://github.com/spree-contrib/spree_mailchimp_ecommerce
      # https://github.com/spree/spree/blob/master/backend/app/controllers/spree/admin/orders/customer_details_controller.rb

      def edit
      end

      def update
        @pluggto_settings.update(pluggto_settings_params)
        redirect_to edit_admin_pluggto_settings_path
      end

      def upload_all_products
        flash[:success] = Spree.t(:pluggto_products_being_uploaded)
        ::SpreePluggto::UpsertAllProductsJob.perform_later
        redirect_to edit_admin_pluggto_settings_path
      end

      private

      def set_pluggto_settings
        @pluggto_settings = PluggtoSettings.first_or_create
      end

      def pluggto_settings_params
        params.require(:pluggto_settings).permit(:client_id,:client_secret,:username,:password)
      end
    end
  end
end

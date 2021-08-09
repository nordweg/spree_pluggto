module Spree
  module Admin
    class PluggtoFieldsController < ResourceController
      before_action :load_product

      def index
      end

      def update
      end 

      def location_after_save
        admin_product_pluggto_fields_url(@product)
      end

      private

      def load_product
        @product = Spree::Product.friendly.find(params[:product_id])
      end

      def model_class
        @model_class ||= Spree::Product
      end
    end
  end
end

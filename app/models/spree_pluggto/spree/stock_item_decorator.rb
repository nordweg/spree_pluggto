module SpreePluggto
  module Spree
    module StockItemDecorator

      def self.prepended(base)
        base.after_save :update_pluggto_stock
      end

      private

      def update_pluggto_stock
        return unless product.sync_with_pluggto?
        ::SpreePluggto::UpdateStockJob.perform_later(variant_id)
      end
    end
  end
end

Spree::StockItem.prepend(SpreePluggto::Spree::StockItemDecorator)

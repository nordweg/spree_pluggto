module SpreePluggto
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.after_create :upsert_pluggto_product
        base.after_update :upsert_pluggto_product
      end

      private

      def upsert_pluggto_product
        ::SpreePluggto::UpsertProductJob.perform_later(pluggto_product)
      end

    end
  end
end

Spree::Product.prepend(SpreePluggto::Spree::ProductDecorator)

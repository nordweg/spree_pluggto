module SpreePluggto
  module Spree
    module ProductDecorator

      # https://guides.spreecommerce.org/developer/customization/logic.html
      # self.prepended is needed to access class-level methods, like has_many, scopes and callbacks
      def self.prepended(base)
        base.after_create :upsert_pluggto_product, if: :sync_with_pluggto?
        base.after_update :upsert_pluggto_product, if: :sync_with_pluggto?
      end

      private

      def upsert_pluggto_product
        ::SpreePluggto::UpsertProductJob.perform_later(self.id)
      end

    end
  end
end

Spree::Product.prepend(SpreePluggto::Spree::ProductDecorator)

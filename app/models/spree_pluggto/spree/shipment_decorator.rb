module SpreePluggto
  module Spree
    module ShipmentDecorator

      # https://guides.spreecommerce.org/developer/customization/logic.html
      # self.prepended is needed to access class-level methods, like has_many, scopes and callbacks
      def self.prepended(base)
        base.state_machine.after_transition to: :shipped, do: :update_pluggto_order, if: :pluggto_order?
      end

      private

      def update_pluggto_order
        ::SpreePluggto::UpdatePluggtoOrderJob.perform_later(order.number)
      end

      def pluggto_order?
        order.channel == "pluggto"
      end
    end
  end
end

Spree::Shipment.prepend(SpreePluggto::Spree::ShipmentDecorator)

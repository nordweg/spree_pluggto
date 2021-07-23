# Handles what should happen when we receive a notification from Pluggto
module SpreePluggto
  class NotificationHandler
    attr_reader :resource_type, :resource_id, :action

    def initialize(notification)
      @resource_type = notification[:type]
      @resource_id   = notification[:id]
      @action        = notification[:action]
    end

    def call
      case resource_type
      when "products"
        SpreePluggto::ProductUpdater.new(resource_id).call if action == 'updated'
      when "orders"
        SpreePluggto::OrderCreator.new(resource_id).call if action == 'created'
        SpreePluggto::OrderUpdater.new(resource_id).call if action == 'updated'
      else
        fail Exception.new("Notification type unknown: #{notification_type}")
      end
    end

  end
end

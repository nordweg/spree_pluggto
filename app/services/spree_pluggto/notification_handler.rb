# Handles what should happen when we receive a notification from Pluggto
module SpreePluggto
  class NotificationHandler
    attr_reader :resource_type, :resource_id, :action, :changes

    def initialize(notification)
      @resource_type = notification['type']
      @resource_id   = notification['id']
      @action        = notification['action']
      @changes        = notification['changes']
    end

    def call
      case resource_type
      when "products"
        SpreePluggto::ProductUpdater.call(notification_id) if action == 'updated' && important_changes?
      when "orders"
        SpreePluggto::OrderCreator.call(notification_id) if action == 'created'
        SpreePluggto::OrderUpdater.call(notification_id) if action == 'updated'
      else
        fail Exception.new("Notification type unknown: #{notification_type}")
      end
    end

    def important_changes?
      return true if changes[:status]
      return true if changes[:stock]
    end
  end
end

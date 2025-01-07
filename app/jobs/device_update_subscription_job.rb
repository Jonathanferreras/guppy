class DeviceUpdateSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(device_id)
    mqtt_client = Rails.application.config.mqtt_client

    mqtt_client.subscribe("device-update/device-id-#{device_id}") do |topic, message|
      Rails.logger.info "Received message: #{message} on topic: #{topic}"

      # Add your message processing logic here
      # device_handler = Rails.application.config.device_handler
      # device_handler.process_update(device, message)
    end
  end
end

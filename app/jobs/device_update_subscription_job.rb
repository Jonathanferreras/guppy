class DeviceUpdateSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(device_id)
    mqtt_client = Rails.application.config.mqtt_client
    mqtt_client.subscribe("device-update/device-id-#{device_id}", ->(topic, message) {
      process_device_update(device_id, message)
    })
  end

  def process_device_update(device_id, message)
    device = Device.find_by(uuid: device_id)

    return Rails.logger.error "Device not found for UUID: #{device_id}" unless device

    parsed_message = JSON.parse(message) rescue nil
    if parsed_message
      device_update = DeviceUpdate.new(
        device: device,
        update_type: parsed_message["type"],
        value: parsed_message["value"],
        timestamp: parsed_message["timestamp"]
      )

      if device_update.save
        Rails.logger.info "Device update saved: #{device_update.inspect}"
      else
        Rails.logger.error "Failed to save device update: #{device_update.errors.full_messages.join(", ")}"
      end
    else
      Rails.logger.error "Failed to parse MQTT message: #{message}"
    end
  end
end

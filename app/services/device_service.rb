class DeviceService
  def process_device_update(topic, message)
    update_type = topic.split("/").last
    payload = JSON.parse(message) rescue nil

    if payload
      device = Device.find_or_create_by!(name: payload["device_name"])

      if update_type == "heartbeat"
        device.update(online: payload["online"])
        device.broadcast_device_update
      end

      if payload["timestamp"]
        device.update(last_seen: payload["timestamp"])
        device.broadcast_device_update
      end

      device_update = DeviceUpdate.new(
        device: device,
        payload: payload,
        update_type: update_type
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

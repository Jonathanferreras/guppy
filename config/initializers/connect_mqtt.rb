require "#{Rails.root}/app/services/mqtt_service"

mqtt_client = MqttService.new("localhost")

# Log connection attempt
Rails.logger.info "Connecting to MQTT broker..."

begin
  mqtt_client.connect
  Rails.logger.info "Connected to MQTT broker successfully!"
rescue => e
  Rails.logger.error "Failed to connect to MQTT broker: #{e.message}"
end

Rails.application.config.mqtt_client = mqtt_client

at_exit do
  mqtt_client.disconnect if mqtt_client.connected?
end

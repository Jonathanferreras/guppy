require "#{Rails.root}/app/services/mqtt_service"
require "#{Rails.root}/app/services/device_service"

mqtt_service = MqttService.new("localhost", 1883)
device_service = DeviceService.new
Rails.application.config.mqtt_service = mqtt_service
Rails.application.config.device_service = device_service

# Log connection attempt
Rails.logger.info "Connecting to MQTT broker..."

begin
  mqtt_service.connect
  Rails.logger.info "Connected to MQTT broker successfully!"
rescue => e
  Rails.logger.error "Failed to connect to MQTT broker: #{e.message}"
end


def testHandler(topic, message)
  puts "Received message: #{message} from topic: #{topic}"
end

Rails.application.config.after_initialize do
  Thread.new do
    mqtt_service.subscribe("devices/#", ->(topic, message) { device_service.process_device_update(topic, message) })
  end
end

at_exit do
  mqtt_service.disconnect if mqtt_service.connected?
end

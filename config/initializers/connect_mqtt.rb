require "#{Rails.root}/app/services/mqtt_service"

mqtt_client = MqttService.new("localhost", 1883)

# Log connection attempt
Rails.logger.info "Connecting to MQTT broker..."

begin
  mqtt_client.connect
  Rails.logger.info "Connected to MQTT broker successfully!"
rescue => e
  Rails.logger.error "Failed to connect to MQTT broker: #{e.message}"
end

Rails.application.config.mqtt_client = mqtt_client

# def testHandler(topic, message)
#   puts "Received message: #{message} from topic: #{topic}"
# end

# Rails.application.config.after_initialize do
#   mqtt_client.subscribe("devices/#", ->(topic, message) { testHandler(topic, message) })
# end

at_exit do
  mqtt_client.disconnect if mqtt_client.connected?
end

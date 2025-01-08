require "mqtt"

class MqttService
  @@subscribed_topics = {}

  def initialize(host, port = 1883)
    @client = MQTT::Client.new
    @client.host = host
    @client.port = port
  end

  def connect
    @client.connect
  end

  def disconnect
    @client.disconnect
  end

  def connected?
    @client.connected?
  end

  def subscribe(topic, handler)
    @@subscribed_topics[topic] = true
    Rails.logger.info "Subscribed Topics: #{@@subscribed_topics.inspect}"

    @client.get(topic) do |topic, message|
      puts "Message: #{message} from topic: #{topic}"
      handler.call(topic, message)
    end
  end

  def subscribed?(topic)
    if @@subscribed_topics[topic]
      Rails.logger.info "Already subscribed to topic: #{topic}"
      true
    else
      false
    end
  end

  def publish(topic, message)
    @client.publish(topic, message)
  end
end

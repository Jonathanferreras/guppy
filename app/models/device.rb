class Device < ApplicationRecord
  after_update_commit -> { broadcast_device_update }

  def broadcast_device_update
    Turbo::StreamsChannel.broadcast_replace_to(
      "devices",
      target: "device_#{id}",
      partial: "devices/device",
      locals: { device: self }
    )
  end
end

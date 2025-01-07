module Api
  class DevicesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [ :register, :validate ]

    def list_devices
      @devices = Device.all
      render json: @devices, status: :ok
    end

    def register
      device = Device.find_by(uuid: device_params[:uuid])

      if device
        render json: { error: "Device already registered!" }, status: :conflict
      else
        device = Device.new(device_params)

        if device.save
          run_device_update_subscription(:uuid)
          render json: { message: "Device registered!", device: device }, status: :created
        else
          render json: { error: "Device failed to register" }, status: :internal_server_error
        end
      end
    end

    def validate
      device = Device.find_by(uuid: device_params[:uuid])

      if device
        run_device_update_subscription(device.uuid)
        render json: { message: "Device validated!" }, status: :ok
      else
        render json: { message: "Invalid Device, please register." }, status: :unprocessable_entity
      end
    end

    def run_device_update_subscription(device_id)
      mqtt_client = Rails.application.config.mqtt_client

      if !mqtt_client.subscribed?("device-update/device-id-#{device_id}")
        DeviceUpdateSubscriptionJob.perform_later(device_id)
      end
    end

    def device_params
      params.require(:device).permit(:name, :uuid, :last_seen, :online)
    end
  end
end

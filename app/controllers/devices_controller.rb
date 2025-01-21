class DevicesController < ApplicationController
  def index
    @devices = Device.all
  end

  def new
    @device = Device.new
  end

  def create
    # User inputs a Name and selects from a dropdown type of device firmware (guppy)
    # On form submission, a uuid, mqtt username and password are generated
    # The user is presented with the device's details and the option to download a arduino file with the device's credentials embedded
    puts "Received parameters: #{params.inspect}"

    @device = Device.new(device_params)
    @device.uuid = SecureRandom.uuid
    @device.online = false
    @device.last_seen = nil


    if @device.save
      redirect_to devices_path
    else
      render :new
    end
  end

  def updates
    device = Device.find_by(uuid: device_update_params[:id])
    puts "Device: #{device.inspect}"

    if device
      device_updates = DeviceUpdate.where(device_id: device.id).order(created_at: :desc)
      puts "Device Updates: #{device_updates.inspect}"

      if device_updates
        return @updates = device_updates
      end
    end

    @updates = []
  end

  def device_params
    params.require(:device).permit(:name)
  end

  def device_update_params
    params.permit(:id)
  end
end

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

  def device_params
    params.require(:device).permit(:name)
  end
end

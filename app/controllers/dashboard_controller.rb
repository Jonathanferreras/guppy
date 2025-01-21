class DashboardController < ApplicationController
  def index
    @devices = Device.all
  end
end

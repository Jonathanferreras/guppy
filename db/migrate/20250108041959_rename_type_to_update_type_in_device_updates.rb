class RenameTypeToUpdateTypeInDeviceUpdates < ActiveRecord::Migration[8.0]
  def change
    rename_column :device_updates, :type, :update_type
  end
end

class CreateDeviceUpdates < ActiveRecord::Migration[8.0]
  def change
    create_table :device_updates do |t|
      t.references :device, null: false, foreign_key: true
      t.json :payload

      t.timestamps
    end
  end
end

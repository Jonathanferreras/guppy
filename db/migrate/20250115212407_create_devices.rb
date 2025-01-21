class CreateDevices < ActiveRecord::Migration[8.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :uuid
      t.boolean :online
      t.timestamp :last_seen

      t.timestamps
    end
  end
end

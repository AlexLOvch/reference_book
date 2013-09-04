class CreateStorages < ActiveRecord::Migration
  def change
    create_table :storages do |t|
      t.integer :attrib_id, null: false
      t.integer :record_no, null: false
      t.string :data

      t.timestamps
    end
  end
end

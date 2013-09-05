class AddIndexes < ActiveRecord::Migration
  def change
    add_index :storages, :data
    add_index :storages, :record_no
    add_index :storages, [:record_no, :attrib_id]
  end
end

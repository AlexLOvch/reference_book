class CreateAttribs < ActiveRecord::Migration
  def change
    create_table :attribs do |t|
      t.string :name, null: false
      t.string :data_type, null: false, default: 'String'
      t.integer :referencebook_id, null: false

      t.timestamps
    end
  end
end

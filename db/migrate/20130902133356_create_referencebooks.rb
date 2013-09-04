class CreateReferencebooks < ActiveRecord::Migration
  def change
    create_table :referencebooks do |t|
      t.string :name, null: false
      t.integer :record_count,  default: 0
      t.timestamps
    end
  end
end

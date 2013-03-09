class CreateKases < ActiveRecord::Migration
  def change
    create_table :kases do |t|
      t.string :name
      t.integer :new_id
      t.integer :old_id
      t.text :response
      t.integer :transfer_id
      t.text :xml

      t.timestamps
    end
  end
end

class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :body
      t.text :xml
      t.text :response
      t.integer :transfer_id
      t.integer :new_id
      t.integer :old_id

      t.timestamps
    end
  end
end

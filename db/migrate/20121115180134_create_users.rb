class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :old_id
      t.integer :new_id
      t.text :xml
      t.text :response

      t.timestamps
    end
  end
end

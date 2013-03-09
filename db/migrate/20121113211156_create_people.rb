class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.integer :old_id
      t.integer :new_id
      t.integer :company_id
      t.text :tag

      t.timestamps
    end
  end
end

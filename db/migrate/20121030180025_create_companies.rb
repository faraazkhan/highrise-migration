class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :old_id
      t.integer :new_id
      t.text :xml

      t.timestamps
    end
  end
end

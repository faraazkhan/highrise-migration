class CreateTaskCategories < ActiveRecord::Migration
  def change
    create_table :task_categories do |t|
      t.string :name
      t.integer :new_id
      t.integer :old_id
      t.text :xml

      t.timestamps
    end
  end
end

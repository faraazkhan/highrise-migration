class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.text :description
      t.integer :old_id
      t.integer :new_id
      t.text    :tag
      t.text    :xml
      t.text :response
      t.integer :transfer_id

      t.timestamps
    end
  end
end

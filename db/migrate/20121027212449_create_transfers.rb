class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.string :api_token
      t.string :url

      t.timestamps
    end
  end
end

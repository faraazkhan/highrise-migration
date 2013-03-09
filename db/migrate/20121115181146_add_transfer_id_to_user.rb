class AddTransferIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :transfer_id, :integer
  end
end

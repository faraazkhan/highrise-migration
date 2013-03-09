class AddMigratedUsersToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :migrated_users, :boolean
  end
end

class AddPerformedToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :performed, :boolean
  end
end

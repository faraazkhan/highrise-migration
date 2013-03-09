class AddUnzippedToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :unzipped, :boolean
  end
end

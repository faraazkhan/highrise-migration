class AddFileToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :file, :string
  end
end

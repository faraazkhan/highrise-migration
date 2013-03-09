class ChangeDescriptionToNameOnTransfer < ActiveRecord::Migration
  def change
    rename_column :deals, :description, :name
  end

end

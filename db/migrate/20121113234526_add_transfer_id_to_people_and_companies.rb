class AddTransferIdToPeopleAndCompanies < ActiveRecord::Migration
  def change
    add_column :people, :transfer_id, :integer
    add_column :companies, :transfer_id, :integer
  end
end

class AddTransferIdToDealCategoriesAndTaskCategories < ActiveRecord::Migration
  def change

    add_column :deal_categories, :transfer_id, :integer
    add_column :task_categories, :transfer_id, :integer
  end
end

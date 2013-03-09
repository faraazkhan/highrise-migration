class AddResponseToCategories < ActiveRecord::Migration
  def change
    add_column :deal_categories, :response, :text
    add_column :task_categories, :response, :text
  end
end

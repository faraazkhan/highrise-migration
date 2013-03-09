class AddTagsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :tag, :text
  end
end

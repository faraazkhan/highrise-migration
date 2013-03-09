class AddResponseToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :response, :text
  end
end

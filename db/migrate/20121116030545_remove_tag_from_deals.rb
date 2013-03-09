class RemoveTagFromDeals < ActiveRecord::Migration
  def change
    remove_column :deals, :tag
  end

end

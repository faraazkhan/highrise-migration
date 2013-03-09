class AddPartiesToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :parties, :text
  end
end

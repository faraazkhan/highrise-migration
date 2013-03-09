class AddXmlAndResponseToPerson < ActiveRecord::Migration
  def change
    add_column :people, :xml, :text
    add_column :people, :response, :text
  end
end

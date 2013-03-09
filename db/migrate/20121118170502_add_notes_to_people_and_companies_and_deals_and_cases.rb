class AddNotesToPeopleAndCompaniesAndDealsAndCases < ActiveRecord::Migration
  def change
    add_column :people, :notes, :text
    add_column :companies, :notes, :text
    add_column :deals, :notes, :text
    add_column :kases, :notes, :text

  end
end

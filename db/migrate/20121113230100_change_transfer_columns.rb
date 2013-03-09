class ChangeTransferColumns < ActiveRecord::Migration
  def change
    rename_column :transfers, :api_token, :source_api_token
    rename_column :transfers, :url, :source_url
    add_column :transfers, :target_api_token, :string
    add_column :transfers, :target_url, :string
    remove_column :transfers, :file
    remove_column :transfers, :unzipped
  end
end

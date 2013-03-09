class UsersController < ApplicationController
  def confirm_migration

    @users = User.find_by_transfer_id(params[:transfer_id])
    
  end
end

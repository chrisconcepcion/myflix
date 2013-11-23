class ChangeInvitations < ActiveRecord::Migration
  def change
  	rename_column :invitations, :invitation_token, :token
  end
end

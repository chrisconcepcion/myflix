class AddRecipientNameToInvitations < ActiveRecord::Migration
  def change
  	add_column :invitations, :recipient_name, :string
  end
end

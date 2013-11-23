class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
    	t.integer :user_id
    	t.string :invitation_token, :message, :recipient_email
    end
  end
end

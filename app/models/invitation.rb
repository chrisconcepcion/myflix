class Invitation < ActiveRecord::Base
 include Tokenable

 belongs_to :user

 validates_presence_of(:user_id)
 validates_presence_of(:recipient_email)

end
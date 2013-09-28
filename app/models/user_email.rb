# attrs:
#  * email
class UserEmail < ActiveRecord::Base
  validates :user_id, :email, :presence => true
  validates_uniqueness_of :email, :scope => :user_id

  belongs_to :user
end

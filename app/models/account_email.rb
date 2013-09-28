# attrs:
#  * email
class AccountEmail < ActiveRecord::Base
  validates :account_id, :email, :presence => true
  validates_uniqueness_of :email, :account_id

  belongs_to :account
end

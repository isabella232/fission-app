class AccountPermission < ActiveRecord::Base
  validates :account_id, :permission_id, :presence => true
  validates_uniqueness_of :permission_id, :scope => :account_id

  belongs_to :account
  belongs_to :permission
end

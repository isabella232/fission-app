class AccountUser < ActiveRecord::Base
  validates :account_id, :user_id
  validates_uniqueness_of :user_id, :scope => :account_id

  belongs_to :user
  belongs_to :account
end

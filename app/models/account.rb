# attrs:
#   * account_id
#   * name
class Account < ActiveRecord::Base

  # validations
  validates :name
  validates_uniqueness_of :name

  # associations
  has_many :users, :through => :account_users
  has_many :emails, :through => :account_emails
  has_many :permissions, :through => :account_permissions
  has_many :request_tokens, :through => :account_request_tokens
end

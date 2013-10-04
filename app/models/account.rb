# attrs:
#   * account_id
#   * name
class Account < ActiveRecord::Base

  include Restrictor

  # validations
  validates :name, presence: true, uniqueness: true

  has_one :owner, :class_name => 'User', :dependent => :nullify, :foreign_key => :base_account_id

  # associations
  has_many :account_users
  has_many :users, :through => :account_users
  has_many :account_emails
  has_many :emails, :through => :account_emails
  has_many :permissions, :through => :account_permissions
  has_many :api_consumers
end

# attrs:
#   * name
#   * description
class Permission < ActiveRecord::Base
  validates :name, :presense => true, :uniqueness => true

  has_many :users, :through => :user_permissions
  has_many :accounts, :through => :account_permissions
end

class UserPermission < ActiveRecord::Base
  validates :user_id, :permission_id, :presence => true
  validates_uniqueness_of :permission_id, :scope => :user_id

  belongs_to :user
  belongs_to :permission
end

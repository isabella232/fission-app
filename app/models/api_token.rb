# attrs:
#   * access_key
#   * secret_key
class ApiToken < ActiveRecord::Base
  validates :user_id, :access_key, :secret_key, presence: true
  validates_uniqueness_of, :secret_key, :scope => :access_key

  belongs_to :user
end

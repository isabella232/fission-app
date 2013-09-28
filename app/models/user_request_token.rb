class UserRequestToken < ActiveRecord::Base
  validates :user_id, :request_token_id, :presence => true
  validates_uniqueness_of :request_token_id, :scope => :user_id

  belongs_to :user
  belongs_to :request_token
end

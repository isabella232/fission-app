class RequestToken < ActiveRecord::Base
  validates :token, presence: true, uniqueness: true

  has_many :accounts, :through => :account_request_tokens
  has_many :users, :through => :user_request_tokens
end

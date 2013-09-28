class AccountRequestToken < ActiveRecord::Base
  validates :account_id, :request_token_id, presence: true
  validates_uniqueness_of :request_token_id, :scope => :account_id

  belongs_to :account
  belongs_to :request_token
end

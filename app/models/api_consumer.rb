class ApiConsumer < ActiveRecord::Base

  include Restrictor

  validates :account_id, :key, :secret, presence: true
  validates :account_id, uniqueness: true

end

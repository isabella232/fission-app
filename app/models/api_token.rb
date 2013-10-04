class ApiToken < ActiveRecord::Base

  include Restrictor

  validates :api_consumer_id, :user_id, :key, :key, presence: true
  validates_uniqueness_of :key, :scope => :api_consumer_id

  belongs_to :user
  belongs_to :api_consumer
end

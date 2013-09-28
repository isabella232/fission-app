# attrs:
#  * token
#  * uuid
#  * location
#  * state
#  * reason
class Job < ActiveRecord::Base
  validates :token, :uuid, :location, :state, :presence => true

  belongs_to :user
  belongs_to :account
end

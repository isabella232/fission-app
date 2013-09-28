require 'digest/sha2'
# attrs:
#   * username
#   * password
#   * name
class User < ActiveRecord::Base

  # validations
  validates :username, presence: true, uniqueness: true

  # associations
  has_many :api_tokens
  has_many :request_tokens, :through => :user_request_tokens
  has_many :accounts, :through => :account_users
  has_many :permissions, :through => :user_permissions
  has_many :emails, :through => :user_emails

  before_save :set_password_hash, :unless => lambda{|record| record.password.blank?}

  class << self
    def authenticate_by_api_token(key, secret)
      token = ApiToken.where(:access_key => key, :secret_key => secret).first
      if(token && (token.expires.nil? || token.expires > Time.now))
        token.user
      end
    end
  end

  private

  def password_hash
    Digest::SHA512.hexdigest("#{username}:#{password}")
  end

  def set_password_hash
    password = password_hash
  end
end

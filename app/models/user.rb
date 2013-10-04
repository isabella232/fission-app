class User < ActiveRecord::Base

  include Restrictor
  include ActiveSupport::Configurable

  # validations
  validates :username, :base_account_id, presence: true, uniqueness: true

  # associations
  has_many :identities
  has_many :api_tokens
  has_many :account_users
  has_many :user_permissions
  has_many :user_emails
  has_many :accounts, :through => :account_users
  has_many :permissions, :through => :user_permissions

  belongs_to :base_account, :class_name => 'Account', :dependent => :destroy, :foreign_key => :base_account_id, :inverse_of => :owner

  before_validation :create_base_account

  def permitted?(*args)
    true
  end
  alias_method :permit?, :permitted?

  def current_account
    Account.where(:id => config.account_id).first || base_account
  end

  protected

  def create_base_account
    acct = Account.create(:name => username)
    unless(acct.save)
      raise FissionApp::Errors::Error.new(
        "Failed to create account: #{acct.errors.full_messages.join(', ')}", :internal_server_error
      )
    end
    self.base_account_id = acct.id
    true
  end

end

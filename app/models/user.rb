class User < ModelBase

  bucket :users

  value :username
  value :name
  value :updated_at, :class => Time
  value :created_at, :class => Time
  value :permissions, :class => Array

  index :username, :unique => true

  link :base_account, Account
  links :identities, Identity

  class << self
    def display_attributes
      [:name]
    end
  end

  def create_account(name=nil)
    act = Account.new(name || username).save
    # make owner
    act.owner = self
    act.save
    # assign to me if none
    unless(base_account)
      base_account = act
      save
    end
    act
  end

  def permitted?(*args)
    args.detect do |permission|
      permissions.include?(permission)
    end
  end

end

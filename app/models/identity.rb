class Identity < ModelBase

  include ::OmniAuth::Identity::Model
  include ::OmniAuth::Identity::SecurePassword

  has_secure_password

  def before_create
    values[:provider_identity] = [values[:provider], values[:uid]].compact.join('_')
  end

  def after_create
    u = self.user
    u.add_identities self
    u.save
  end

  bucket :identities

  value :provider_identity, :class => String
  value :uid, :class => String
  value :provider, :class => String
  value :email, :class => String
  value :credentials
  value :extras
  value :data
  value :password_digest, :class => String

  attr_accessor :password_confirmation

  link :user, User

  index :provider_identity, :unique => true

  class << self

    def lookup_key(uid, provider=nil)
      key = [provider, uid].compact.join('_').to_sym
    end

    def lookup(uid, provider=nil)
      self[lookup_key(uid, provider)]
    end

    def locate(search_hash)
      puts '&' * 50
      p search_hash
      raise 'wat'
    end

    def find_or_create_via_omniauth(attributes, existing_user=nil)
      provider = attributes[:provider] || 'fission'
      unique_id = attributes[:uid] || attributes[:unique_id]
      identity = lookup(unique_id, provider)
      if(identity)
        Rails.logger.info "Found existing identity: #{identity.inspect}"
      else
        Rails.logger.info "No existing identity found! Creating new user"
        username = attributes[:info].try(:[], :nickname) ||
          attributes[:info].try(:[], :login) ||
          attributes[:info].try(:[], :email) ||
          unique_id
        user = User.by_username(username)
        if(user)
        else
          identity = Identity.create(
            attributes.merge(
              :username => username,
              :unique_id => unique_id,
              :password => 'stub'
            )
          )
          identity.data = attributes
          identity.provider = provider
          identity.uid = unique_id
          identity.password = 'stub'
          unless(identity.save)
            Rails.logger.error identity.errors.inspect
            raise identity.errors unless identity.save
          end
        end
      end
      identity
    end

    def create(attributes)
      username = attributes[:username] || attributes[:unique_id]
      user = User.by_username(username)
      raise 'user exists' if user
      user = User.new
      user.username = username
      user.save
      user.create_account

      Rails.logger.info "New user creation: #{attributes.inspect}"

      identity = Identity.new
      identity.provider_identity = lookup_key(attributes[:unique_id], 'fission')
      identity.password = attributes[:password]
      identity.email = attributes[:email]
      identity.uid = attributes[:unique_id]
      identity.user = user
      unless(identity.save)
        Rails.logger.error identity.errors.inspect
        raise identity.errors
      end
      identity
    end

  end

end

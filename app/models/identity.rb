class Identity < ModelBase

  def before_create
    values[:provider_identity] = [values[:provider], values[:uid]].compact.join('_')
  end

  def after_create
    u = self.user
    u.add_identities self
    u.save
  end

  bucket :identities

  value :provider_identity
  value :uid, :class => String
  value :provider, :class => String
  value :email, :class => String
  value :password, :class => String
  value :credentials
  value :extras
  value :info, :class => Hash, :default => {}

  link :user, User

  index :provider_identity, :unique => true

  class << self

    def auth_key
      'uid'
    end

    def lookup_key(uid, provider=nil)
      key = [provider, uid].compact.join('_').to_sym
    end

    def lookup(uid, provider=nil)
      self[lookup_key(uid, provider)]
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
          attributes[:info].try(:[], :email) ||
          unique_id
        user = User.new(username).save
        identity = Identity.new(lookup_key(unique_id, provider))
        identity[:data] = attributes
        identity[:provider] = provider
        identity[:uid] = unique_id
        identity.user = user
        identity.save
      end
      identity
    end
    alias_method :create, :find_or_create_via_omniauth

  end

end

class Identity < OmniAuth::Identity::Models::ActiveRecord

  ALLOWED_OMNIAUTH_ATTRS = %w(name email nickname first_name last_name location description image phone)

  include Restrictor

  belongs_to :user

  validates :unique_id, :user_id, :provider, presence: true

  class << self

    def build_user(name)
      user = User.new(:username => name)
      begin
        unless(user.save)
          raise FissionApp::Errors::Error.new(
            "Failed to create user: #{user.errors.full_messages.join(', ')}", :internal_server_error
          )
        end
        user
      rescue => e
        user.destroy if user && user.persisted?
        raise
      end
    end

    def find_or_create_via_omniauth(attributes, existing_user=nil)
      attributes[:provider] ||= 'identity'
      u_id = attributes[:uid] || attributes[:unique_id]
      ident = Identity.where(
        :provider => attributes[:provider],
        :unique_id => u_id
      ).first
      unless(ident)
        user = existing_user || build_user(
          attributes[:info].try(:[], :nickname) ||
          attributes[:info].try(:[], :email) ||
          u_id
        )
        ident = Identity.new(:provider => attributes[:provider], :unique_id => u_id)
        ALLOWED_OMNIAUTH_ATTRS.each do |k|
          if(attributes[:info].try(:[], k))
            ident.send("#{k}=", attributes[:info][k])
          end
        end
        unless(ident.password) # non-password identity
          ident.password = ident.password_confirmation = SecureRandom.hex(256)
        end
        ident.user_id = user.id
        unless(ident.save)
          user.destroy unless existing_user
          raise FissionApp::Errors::Error.new("Failed to create user: #{ident.errors.full_messages.join(', ')}", :internal_server_error)
        end
      end
      ident
    end
    alias_method :create, :find_or_create_via_omniauth
=begin
    def create(attributes)
      attributes = attributes.dup
      unless(attributes[:user_id])
        user = User.new(:username => attributes[:unique_id])
        unless(user.save)
          raise FissionApp::Errors::Error.new("Failed to create user: #{user.errors.full_messages.join(', ')}", :internal_server_error)
        end
        attributes[:user_id] = user.id
      end
      attributes[:provider] ||= 'identity'
      res = super(attributes)
      unless(res.persisted?)
        user.destroy
        raise FissionApp::Errors::Error.new("Failed to create user: #{res.errors.full_messages.join(', ')}", :internal_server_error)
      end
      res
    end
=end
  end

end

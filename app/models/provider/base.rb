module Provider
  class Base
    attr_accessor :oauth_hash
    def self.from_oauth_hash(the_oauth_hash)
      return nil unless self.valid_provider?(the_oauth_hash)
      Provider.const_get(the_oauth_hash['provider'].camelize).new(the_oauth_hash)
    end

    def self.valid_provider?(the_oauth_hash)
      the_oauth_hash && the_oauth_hash['provider'] && the_oauth_hash['uid'] && User.omniauth_providers.map(&:to_s).include?(the_oauth_hash['provider'])
    end
    def valid?
      Provider::Base.valid_provider?(oauth_hash)
    end
    def initialize(oauth_hash)
      self.oauth_hash = oauth_hash.to_hash
    end

    def uid
      oauth_hash['extra']['raw_info']['id']
    end
    def provider_name
      oauth_hash['provider']
    end
    def provider_display_name
      oauth_hash['provider'].capitalize
    end

    def email_verified?
      false
    end

    def name
      oauth_hash['extra']['raw_info']['name']
    end

    def first_name
      oauth_hash['extra']['raw_info']['first_name']
    end

    def last_name
      oauth_hash['extra']['raw_info']['last_name']
    end

    def username
      oauth_hash['extra']['raw_info']['username']
    end

    def profile_url
      oauth_hash['extra']['raw_info']['link']
    end

    def photo_url
      oauth_hash['info']['image']
    end
    def email
      oauth_hash['extra']['raw_info']['email']
    end
    def email=(new_email)
      oauth_hash['extra']['raw_info']['email'] = new_email
    end
    def access_token
      self.credentials['token']
    end
    def secondary_token
      self.credentials['secret']
    end
    def token_expires_at
      self.credentials['expires_at']
    end
    def credentials
      oauth_hash['credentials']
    end
  end
end
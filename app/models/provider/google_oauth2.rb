module Provider
  class GoogleOauth2 < Provider::Base
    def first_name
      oauth_hash['extra']['raw_info']['given_name']
    end
    def username
      oauth_hash['extra']['raw_info']['email']
    end
    def provider_display_name
      "Google+"
    end
    def last_name
      oauth_hash['extra']['raw_info']['family_name']
    end
    def secondary_token
      self.credentials['refresh_token']
    end
    def email_verified?
      true
    end
  end
end
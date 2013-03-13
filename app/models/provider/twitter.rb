module Provider
  class Twitter < Provider::Base
    def username
       oauth_hash['extra']['raw_info']['screen_name']
    end
    def secondary_token
      self.credentials['secret']
    end
    def profile_url
      oauth_hash['info']['urls']['twitter']
    end

  end
end
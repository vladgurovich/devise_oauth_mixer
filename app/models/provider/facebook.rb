module Provider
  class Facebook < Provider::Base
    def email
      oauth_hash['info']['email']
    end
    def email_verified?
      true
    end
  end
end
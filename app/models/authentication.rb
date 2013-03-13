class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :uid, :scope => [:provider]
  validates_uniqueness_of :email, :scope => [:provider]
  attr_accessible :authentication_token, :email, :provider, :secondary_token, :token_expires_at, :uid, :user_id, :username

  def self.find_or_create_from_oauth_provider(oauth_provider)
    where( :provider => oauth_provider.provider_name, :uid => oauth_provider.uid).first_or_create do |auth|
      auth.load_attributes_from_provider(oauth_provider)
    end
  end

  def load_attributes_from_provider(oauth_provider)

    self.provider = oauth_provider.provider_name
    self.uid = oauth_provider.uid
    self.username = oauth_provider.username
    self.email = oauth_provider.email
    self.authentication_token = oauth_provider.access_token
    self.secondary_token = oauth_provider.secondary_token
    self.token_expires_at = Time.at(oauth_provider.token_expires_at.to_i).utc if oauth_provider.token_expires_at
  end
end

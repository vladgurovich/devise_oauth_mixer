class User < ActiveRecord::Base
  has_many :authentications

  validates_presence_of :first_name
  validates_presence_of :email, :if => :validate_presence_of_email?
  validates_uniqueness_of :email, :if => :validate_uniqueness_of_email?
  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?

  before_validation :postpone_email_change_until_confirmation, :on => :create, :unless => :validate_uniqueness_of_email?

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :confirmable, :recoverable, :rememberable, :trackable#, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me

  def self.find_or_create_from_oauth_provider(oauth_provider)
    return if oauth_provider.email.blank?
    user = ( User.find_by_email(oauth_provider.email) unless oauth_provider.email.blank?) || User.new do |u|
      u.password = SecureRandom.hex(10)
      u.first_name = oauth_provider.first_name || oauth_provider.name
      u.last_name = oauth_provider.last_name
      u.email = oauth_provider.email
    end
    user.add_or_update_authentication(oauth_provider)
    user.confirm!
    user
  end

  def add_or_update_authentication(oauth_provider)
    auth = authentications.find_or_create_from_oauth_provider(oauth_provider)
    auth.user = self
    auth.save!
  end

  protected

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
  def validate_presence_of_email?
    email == "" || unconfirmed_email.blank?
  end

  def validate_uniqueness_of_email?
    email_changed? && authentications.any?{|auth|auth.email}
  end

  def self.new_with_session(params, session)
    user = super(params,session)
    if session[:omniauth] && oauth_provider = Provider::Base.from_oauth_hash(session[:omniauth])
      user.password = SecureRandom.hex(10)
      user.first_name = oauth_provider.first_name || oauth_provider.name
      user.last_name = oauth_provider.last_name
      user.email = oauth_provider.email
    end
    user
  end


end

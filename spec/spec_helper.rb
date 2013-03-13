# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  RSpec.configure do |config|
    config.include Devise::TestHelpers, :type => :controller
  end

  #Omniauth Mock
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = {
    'provider' => 'facebook',
    'uid' => '12345',
    'info' => {
      'nickname' => 'SomeFacebookUser',
      'email' => 'joe.schmoe@email.com',
      'name' => 'Joe Schmoe',
      'first_name' => 'Joe',
      'last_name' => 'Schmoe',
      'image' => 'http://www.usphs.gov/images/home/facebook-logo.png',
      'urls' => {
        'Facebook' => 'http://www.facebook.com/SomeFacebookUser'
      },
      'verified' => true
    },
    'credentials' => {
      'token' => 'ABCDE123',
      'expires_at' => '3365407645',
      'expires' => true
    },
    'extra' => {
      'raw_info' => {
      'id' => '12345',
      'name' => 'Joe Schmoe',
      'first_name' => 'Joe',
      'last_name' => 'Schmoe',
      'link' => 'http://www.facebook.com/SomeFacebookUser',
      'username' => 'SomeFacebookUser',
      'verified' => true
      }
    }
  }
  OmniAuth.config.mock_auth[:google_oauth2] = {
    'provider' => 'google_oauth2',
    'uid' => '12345',
    'info' => {
      'name' => 'Joe Schmoe',
      'email' => 'joe.schmoe@email.com',
      'first_name' => 'Joe',
      'last_name' => 'Schmoe',
      'image' => 'https://lh6.googleusercontent.com/AAAXXXMbc/photo.jpg'
    },
    'credentials' => {
      'token' => 'ABCDEFKJDFKJG',
      'refresh_token' => 'DJKFJHJDJKFG',
      'expires_at' => 3360228201,
      'expires' => true
    },
    'extra' => {
      'raw_info' => {
        'id' => '12345',
        'email' => 'joe.schmoe@email.com',
        'verified_email' => true,
        'name' => 'Joe Schmoe',
        'given_name' => 'Joe',
        'family_name' => 'Schmoe',
        'link' => 'https://plus.google.com/123243535206534343',
        'picture' => 'https://lh6.googleusercontent.com/AAAXXXMbc/photo.jpg',
        'gender' => 'male',
        'locale' => 'en'
      }
    }
  }

  OmniAuth.config.mock_auth[:twitter] = {
    'provider' => 'twitter',
    'uid' => '12345',
    'info' => {
      'nickname' => 'joeschmoe',
      'name' => 'Joe Schmoe',
      'location' => 'San Francisco, CA',
      'image' => 'http://a0.twimg.com/profile_images/873834873874_normal.jpeg',
      'description' => 'I Sleep All Day',
      'urls' => {
        'Website' => 'http://www.yahoo.com',
        'Twitter' => 'http://twitter.com/joeschmoe'
      }
    },
    'credentials' => {
      'token' => 'ABDZXXEE',
      'secret' => 'XFHHGHGFDX'
    },
    'extra' => {
      'raw_info' => {
        'id' => 26306347,
        'location' => 'San Francisco, CA',
        'name' => 'Joe Schmoe',
        'description' => 'I Sleep All Day',

      }
    }
  }
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end

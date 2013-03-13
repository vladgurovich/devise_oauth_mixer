source 'https://rubygems.org'


gem 'rails', '3.2.11'


gem 'devise'

# oauth clients
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'

# templates
gem 'haml'
gem 'haml-rails'


# database
group :development, :test do
  gem 'mysql2', '0.3.11'
end
group :production do
  gem 'pg'
end

# rails generate simple_form:install --bootstrap
#Inside your views, use the 'simple_form_for' with one of the Bootstrap form
#classes, '.form-horizontal', '.form-inline', '.form-search' or
#  '.form-vertical', as the following:
#
#= simple_form_for(@user, :html => {:class => 'form-horizontal' }) do |form|

gem 'simple_form'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  #gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.3.0.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test do
  gem 'rspec', '>= 2.12.0'
  gem 'rspec-rails', '>= 2.12.0'
  gem 'shoulda-matchers', '1.3.0'
  gem 'factory_girl_rails', '4.1.0'
  gem 'fakeweb', '1.3.0'
  gem 'webrat', '0.7.3'
  gem 'database_cleaner'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

require 'spec_helper'

describe OmniauthCallbacksController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
  describe "#action_missing" do
    context "A new user signing up" do
      context "with a Facebook account" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
          get :facebook
        end
        it "creates a new confirmed user and a new facebook authentication and redirects to complete signup page" do
          User.count.should == 1
          Authentication.count.should == 1
          User.first.authentications.first.provider.should == 'facebook'
          User.first.confirmed?.should be_true
          User.first.email.should_not be_nil
          should redirect_to authentications_path
        end
      end
      context "with a Google account" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
          get :google_oauth2
        end
        it "creates a new confirmed user and a new google authentication and redirects to complete signup page" do
          User.count.should == 1
          Authentication.count.should == 1
          User.first.authentications.first.provider.should == 'google_oauth2'
          User.first.confirmed?.should be_true
          User.first.email.should_not be_nil
          should redirect_to authentications_path
        end
      end
      context "with a Twitter account" do
        before do
         request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
         get :twitter
       end
        it "doesnt creates a new user and redirects to complete signup page" do
          User.count.should == 0
          Authentication.count.should == 0
          should redirect_to show_complete_signup_path
        end
      end
      #context "with an email and password" do
      #  it "creates an unconfirmed user, sends email and redirects to a home page with a notice" do
      #
      #  end
      #end
    end
    context "a user with an existing facebook sign-in" do
      before do
        @user = FactoryGirl.create :confirmed_user, :email => OmniAuth.config.mock_auth[:facebook]['info']['email']
        @facebook_auth = FactoryGirl.create :authentication,
                                            :provider => 'facebook',
                                            :user => @user,
                                            :email => @user.email,
                                            :uid =>OmniAuth.config.mock_auth[:facebook]['extra']['raw_info']['id'],
                                            :authentication_token => 'foo123'
        @user = @facebook_auth.user
      end
      context "signs up via facebook" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
          get :facebook
        end
        it "doesnt create a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "updates facebook auth to existing user" do
          @user.authentications.where('id <> ?', @facebook_auth.id).should_not exist
          @facebook_auth.reload.authentication_token.should_not == 'foo123'
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      context "signs up via google" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
          get :google_oauth2
        end
        it "doesnt create a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "adds google auth to an existing user" do
          @user.authentications.reload.where(:provider => 'google_oauth2').should exist
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      context "signs up via twitter" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
          get :twitter
        end

        it "does not create a new user and redirects to complete signup page" do
          User.where('id <> ?', @user.id).should_not exist
          should redirect_to complete_signup_path
        end
      end
      #context "signs up via email and password" do
      #  it "creates an uncofirmed user, sends email and redirects to homepage with a notice" do
      #
      #  end
      #end
    end
    context "a user with an existing google sign-in" do
      before do
        @user = FactoryGirl.create :confirmed_user, :email => OmniAuth.config.mock_auth[:google_oauth2]['info']['email']
        @google_auth = FactoryGirl.create :authentication,
                                          :provider => 'google_oauth2',
                                          :user => @user,
                                          :email => @user.email,
                                          :uid =>OmniAuth.config.mock_auth[:google_oauth2]['extra']['raw_info']['id'],
                                          :authentication_token => 'foo123'
        @user = @google_auth.user
      end
      context "signs up via facebook" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
          get :facebook
        end
        it "doesnt add a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "adds facebook auth to existing user" do
          @user.authentications.reload.where(:provider => 'facebook').should exist
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      context "signs up via google" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
          get :google_oauth2
        end
        it "doesnt add a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "updates google auth for existing user" do
          @user.authentications.where('id <> ?', @google_auth.id).should_not exist
          @google_auth.reload.authentication_token.should_not == 'foo123'
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      context "signs up via twitter" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
          get :twitter
        end
        it "doesnt create a new user & redirects to complete signup page" do
          User.where('id <> ?', @user.id).should_not exist
          should redirect_to complete_signup_path
        end
      end
      #context "signs up via email and password" do
      #  it "creates a new unformed user" do
      #
      #  end
      #  it "sends out confirmation email" do
      #
      #  end
      #  it "redirects to homepages with a notice" do
      #
      #  end
      #end
    end
    context "a user with an existing twitter login" do
      before do
        @user = FactoryGirl.create :confirmed_user, :email => OmniAuth.config.mock_auth[:google_oauth2]['info']['email']
        @twitter_auth = FactoryGirl.create :authentication,
                                           :provider => 'twitter',
                                           :user => @user,
                                           :email => nil,
                                           :uid =>OmniAuth.config.mock_auth[:twitter]['extra']['raw_info']['id'],
                                           :authentication_token => 'foo123'
        @user = @twitter_auth.user
      end
      context "signs up via twitter " do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
          get :twitter
        end
        it "doesnt create a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "updates twitter auth for existing user" do
          @user.authentications.where('id <> ?', @twitter_auth.id).should_not exist
          @twitter_auth.reload.authentication_token.should_not == 'foo123'
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      context "signs up via facebook" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
          get :facebook
        end
        it "doesnt create a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "adds new facebook auth to existing user" do
          @user.authentications.reload.where(:provider => 'facebook').should exist
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      context "signs up with google" do
        before do
          request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
          get :google_oauth2
        end
        it "doesnt create a new user" do
          User.where('id <> ?', @user.id).should_not exist
        end
        it "adds google auth to existing user" do
          @user.authentications.reload.where(:provider => 'google_oauth2').should exist
        end
        it "signs in and redirects to the dashboard" do
          should redirect_to authentications_path
        end
      end
      #context "signs ip with email and password" do
      #  it "creates a new unconfirmed user" do
      #
      #  end
      #  it "redirects to a home page with a notice"
      #end

    end
    #context "a user with an existing email login" do
    #
    #end
  end

end
require 'spec_helper'

describe ConfirmationsController do
  render_views
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET 'complete_signup'" do
    context "for a confirmed user" do
      before do
        @user = FactoryGirl.create :confirmed_user
        session[:complete_signup_for] = @user.id
        get :show_complete_signup
      end
      it "renders a complete signup form with user's name and email filled out" do
        should respond_with :ok
        should render_template ['layouts/application', 'registration/show_complete_signup']
        response.body.should have_selector "input#user_name[value='#{@user.name}']"
        response.body.should have_selector "input#user_email[value='#{@user.email}']"
        controller.resource.should == @user
      end
    end
    context "for an unconfirmed user" do
      before do
        @user = FactoryGirl.create :user
        session[:complete_signup_for] = @user.id
        get :show_complete_signup
      end
      it "renders a complete signup form with user's name but without his email" do
        should respond_with :ok
        should render_template ['layouts/application', 'registration/show_complete_signup']
        response.body.should have_selector "input#user_name[value='#{@user.name}']"
        response.body.should_not have_selector "input#user_email[value='#{@user.email}']"
        controller.resource.should == @user
      end
    end
  end

  describe "POST 'complete_signup'" do
    context "if email is blank" do
      before do
        @user = FactoryGirl.create :user
        session[:complete_signup_for] = @user.id
        post :complete_signup
      end
      it "redirects to complete_signup with a notice" do
        should render_template ['layouts/application', 'registration/show_complete_signup']
        flash[:alert].should == I18n.t('registrations.complete_profile.need_email_to_complete_profile')
      end
    end
    context "if email matches existing user's email" do
      before do
        @old_user = FactoryGirl.create :user
        @user = FactoryGirl.create :user
        session[:complete_signup_for] = @user.id
        post :complete_signup, :user => { :email => @old_user.email }
      end
      it "display error notice and a link to send password reset" do
        should render_template ['layouts/application', 'registration/show_complete_signup']
        flash[:alert].should == I18n.t('registrations.complete_profile.need_email_to_complete_profile')
      end
    end
    context "for a confirmed user" do
      context "if email has changed" do
        it "sends confirmation email and redirects to homepage with notice" do
        end
      end
      context "if email hasnt changed" do
        it "redirects to user dashboard" do

        end
      end
    end
    context "for an unconfirmed user" do
      it "sends confirmation email and redirects to homepage with notice" do

      end
    end
  end

end

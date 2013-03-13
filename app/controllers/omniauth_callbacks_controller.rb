class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :set_oauth_provider



  def action_missing(provider)
    redirect_to invalid_provider_path if provider.to_s != @oauth_provider.provider_name

    if existing_auth = Authentication.find_by_provider_and_uid(@oauth_provider.provider_name, @oauth_provider.uid)
      if existing_auth.user.confirmed?
        update_existing_auth_and_redirect(existing_auth)
      else
        complete_signup
      end
    else
      resource = self.send "current_#{resource_name}"
      if resource
        resource.add_or_update_authentication(@oauth_provider)
        redirect_to resource_path(resource)
      else
        find_or_create_new_resource_and_redirect
      end
    end
  end

  private

  def complete_signup
    session[:omniauth] = request.env['omniauth.auth']
    redirect_to complete_signup_path
  end

  def find_or_create_new_resource_and_redirect
    if @oauth_provider.email && @oauth_provider.email_verified?
      resource =  resource_name.to_s.classify.constantize.find_or_create_from_oauth_provider(@oauth_provider)
      sign_in_and_redirect(resource_name, resource)
    else
      complete_signup
    end
  end

  def update_existing_auth_and_redirect(existing_auth)
    existing_auth.load_attributes_from_provider(@oauth_provider)
    existing_auth.save!
    sign_in_and_redirect(resource_name, existing_auth.send(resource_name))
  end


  def set_oauth_provider
    @oauth_provider = Provider::Base.from_oauth_hash request.env['omniauth.auth']
    unless @oauth_provider
      flash[:alert] = 'Invalid OAuth Credentials'
      redirect_to root_path
    end
  end
end
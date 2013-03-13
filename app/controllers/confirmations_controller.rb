class ConfirmationsController < Devise::ConfirmationsController
 before_filter :require_no_authentication, :only =>[:show_complete_signup, :complete_signup]
 before_filter :set_oauth_provider, :only =>[:show_complete_signup, :complete_signup]
  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    #lookup user by confirmation token
    if self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token])
      # if that user's unconfirmed email is the same as some confirmed users email
      if confirmed_resource = resource_class.find_by_email(self.resource.unconfirmed_email)
        # take unconfirmed users auth and add it to the confirmed user and delete the unconfirmed user
        self.resource.authentications.update_all(:user_id => confirmed_resource.id)
        self.resource.destroy
        self.resource = confirmed_resource
      else
        # if that users unconfirmed email is not the same as somebodys email
        # then confirm this user
        self.resource.confirm!
      end

      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      # render invalid token error
      flash[:alert] = "Invalid Confirmation Token"
      redirect_to root_path
    end
  end


  def show_complete_signup
   
    if existing_auth = Authentication.find_by_provider_and_uid(@oauth_provider.provider_name, @oauth_provider.uid)
      self.resource = existing_auth.user
      self.resource.email ||= self.resource.unconfirmed_email
    else
      build_resource
    end
  end

  def complete_signup
   
    
    if existing_auth = Authentication.find_by_provider_and_uid(@oauth_provider.provider_name, @oauth_provider.uid)
      existing_auth.load_attributes_from_provider @oauth_provider
      existing_auth.save!
      self.resource = existing_auth.user
    else
      build_resource
      self.resource.authentications.build(
        :provider => @oauth_provider.provider_name,
        :uid => @oauth_provider.uid,
        :username => @oauth_provider.username,
        :email => @oauth_provider.email,
        :authentication_token => @oauth_provider.access_token,
        :secondary_token => @oauth_provider.secondary_token,
        :token_expires_at => (@oauth_provider.token_expires_at && Time.at(@oauth_provider.token_expires_at.to_i).utc )
      )
    end
    if self.resource.update_attributes(resource_params)
      session[:omniauth] = nil
      #sign_in_and_redirect(:user, self.resource, :notice => "Thanks for confirming '#{self.resource.email}'")
      if successfully_sent?(resource)
        respond_with({}, :location => after_resending_confirmation_instructions_path_for(resource_name))
      else
        respond_with(resource)
      end
    else
      flash[:error] = resource.errors.full_messages.join('\n')
      render :action => 'show_complete_signup'
    end

  end
  
  private
  
  def set_oauth_provider
    @oauth_provider = Provider::Base.from_oauth_hash request.env['omniauth.auth']
    unless @oauth_provider
      flash[:alert] = 'Invalid Oauth Credentials'
      redirect_to root_path
    end
  end


end
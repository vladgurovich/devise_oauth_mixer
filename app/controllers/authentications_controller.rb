class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @authentications = current_user.authentications
  end
  def delete
    current_user.authentications.find(params[:id]).destroy if params[:id]
    redirect_to authentications_path
  end
end

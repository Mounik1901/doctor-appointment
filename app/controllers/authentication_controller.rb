class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate
  
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password], auth_params[:user_type]).tokenize
    if auth_token
    	render json: { auth_token: auth_token }
		else
			render json: { error_message: "Credentials are not valid" }, :status => :unprocessable_entity    
		end
  end

  private

  def auth_params
    params.permit(:email, :password, :user_type)
  end
end
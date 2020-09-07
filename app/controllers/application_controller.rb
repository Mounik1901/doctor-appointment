class ApplicationController < ActionController::API
	before_action :authorize_request

	def authorize_request
		authorize_check = authorize_api_request(request.headers)
		if authorize_check
	  	@current_user = authorize_check
	  else
	  	render json: {message: "user is not authorized"}, :status => :unauthorized
	  end
	end

	private
	def authorize_api_request headers
		if headers['Authorization'].present?
			auth_header = headers['Authorization'].split(' ').last
			decoded_payload = JsonWebToken.decode(auth_header)
			user ||= decoded_payload[:user_type] == "Doctor" ? Doctor.find_by(id: decoded_payload[:user_id]) : Patient.find_by(id: decoded_payload[:user_id])
		end
	end
end

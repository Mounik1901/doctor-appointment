class PatientsController < ApplicationController
	skip_before_action :authorize_request, only: :create

	def create
		user = Patient.new(patient_params)
		if user.save
			auth_token = AuthenticateUser.new(user.email, user.password, user.class.name).tokenize
			if auth_token
				render json: { message: "Account has been created.....!", auth_token: auth_token }
			else
				render json: { message: "Credentials are not valid" }, :status => :unprocessable_entity
			end
		else
			render json: { error_messages: user.errors.full_messages }, :status => :unprocessable_entity
		end
	end

	private

	def patient_params
		params.permit(
			:first_name,
			:last_name,
			:email,
			:password,
			:password_confirmation,
			:phone_number
		)
	end
end
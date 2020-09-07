class DoctorAvailabilitiesController < ApplicationController
	before_action :check_for_doctor

	def new
	end

	def create
		doctor_availability = DoctorAvailability.new(doctor_availability_params)
		doctor_availability.doctor = @current_user
		if doctor_availability.save
			render json: {message: "Time slot availability created"}
		else
			render json: { error_messages: doctor_availability.errors.full_messages }, :status => :unprocessable_entity
		end
	end

	def index
		render json: { slot_availabilties: @current_user.doctor_availabilities.where(slot_occupied: false) }
	end

	private

	def check_for_doctor
		render status: :unauthorized if @current_user.class.name != "Doctor"
	end

	def doctor_availability_params
		params.permit(
			:date,
			:start_time,
			:end_time,
			:is_available,
			:slot_occupied,
			:reason_of_unavailability
		)
	end
end

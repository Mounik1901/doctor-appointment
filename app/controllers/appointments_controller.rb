class AppointmentsController < ApplicationController
	before_action :check_for_patient

	def create
		appointment = Appointment.new(appointment_params)
		if appointment.save
			get_doctor(appointment_params[:doctor_id]).update_time_slot(appointment.start_time)
			render json: {message: "Appointment has been taken successfully"}
		else
			render json: { error_messages: appointment.errors.full_messages }, :status => :unprocessable_entity
		end
	end

	private
	def check_for_patient
		render status: :unauthorized if @current_user.class.name != "Patient"
	end
	
	def appointment_params
		params.permit(
			:start_time,
			:end_time,
			:status,
			:fee,
			:appointment_date,
			:doctor_id,
			:patient_id
		)
	end

	def get_doctor id
		Doctor.find(id)
	end
end

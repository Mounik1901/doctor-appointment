class DoctorsController < ApplicationController
	skip_before_action :authorize_request, only: :create
  before_action :check_for_doctor, only: [:appointments]

  def create
    user = Doctor.new(doctor_params)
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

  def appointments
    @appointments = get_appointments(params[:date], params[:results_for], params[:doctor_id]).group_by {|a| Doctor.find(a.doctor_id).first_name}
    render json: { appointments: @appointments}
  end

  private
  def doctor_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :phone_number,
      :qualification,
      :description
    )
  end

  def get_appointments date, results_for, doctor_id
    date, results_for = Date.parse(date), results_for
    if doctor_id.present?
      doctor = Doctor.find_by(id: doctor_id)
      doctor_appointments = doctor.appointments
      appointments = results_for == "day" ? doctor_appointments.where(appointment_date: date) : doctor_appointments.where(appointment_date: [date.at_beginning_of_week..date.at_end_of_week])
    else
      appointments = results_for == "day" ? Appointment.where(appointment_date: date) : Appointment.where(appointment_date: [date.at_beginning_of_week..date.at_end_of_week])
    end
  end

  def check_for_doctor
    if params[:doctor_id].present?
      if Doctor.find_by(id: params[:doctor_id]).nil? || @current_user.id.to_s != params[:doctor_id]
        render json: {message: "Unauthorized or doctor hasn't been found with provided id"}
      end
    end
  end
end
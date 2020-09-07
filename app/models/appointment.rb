class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  validates_presence_of :start_time, :fee, :appointment_date
  enum status: { active: 0, completed: 1, cancelled: 2}
end


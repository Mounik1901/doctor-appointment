class DoctorAvailability < ApplicationRecord
  belongs_to :doctor
  default_scope { where(slot_occupied: false) }

	validates_presence_of :date, :start_time
end

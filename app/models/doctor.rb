class Doctor < ApplicationRecord

	has_many :doctor_availabilities
	has_many :appointments
	has_many :patients, through: :appointments

	has_secure_password
	validates_presence_of :first_name, :last_name, :email, :password_digest, :phone_number, :qualification, :description
	validates_uniqueness_of :email, :phone_number
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :phone_number, :presence => true, :numericality => true, :length => { :minimum => 10, :maximum => 15 } 


	def update_time_slot time
		self.doctor_availabilities.where(start_time: time).update(slot_occupied: true)
	end
end

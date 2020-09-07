class Patient < ApplicationRecord

	has_many :appointments
	has_many :doctors, through: :appointments

	has_secure_password
	validates_presence_of :first_name, :last_name, :email, :password_digest
	validates_uniqueness_of :email, :phone_number
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :phone_number, :presence => true, :numericality => true, :length => { :minimum => 10, :maximum => 15 } 
end
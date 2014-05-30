class User < ActiveRecord::Base
	#Constant
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#Validations
	validates :name, 	presence: true, length: { maximum: 50 }	
	validates :email, 	presence: true, format: { with: EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	#Callbacks
	before_save { self.email = self.email.downcase }

	#Rails will take care of password stuff with this call
	has_secure_password
end

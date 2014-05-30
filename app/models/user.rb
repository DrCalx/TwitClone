class User < ActiveRecord::Base
	#Constant
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#Validations
	validates :name, 	presence: true, length: { maximum: 50 }	
	validates :email, 	presence: true, format: { with: EMAIL_REGEX },
						uniqueness: { case_sensitive: false }

	#Callbacks
	before_save { self.email = self.email.downcase }
end

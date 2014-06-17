class User < ActiveRecord::Base
	#db associations (Rails will add methods and validations)
	has_many :microposts, dependent: :destroy

	#Constant
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	#Validations
	validates :name, 	presence: true, length: { maximum: 50 }	
	validates :email, 	presence: true, format: { with: EMAIL_REGEX },
						uniqueness: { case_sensitive: false }
	validates :password, length: { minimum: 6 }

	#Callbacks
	before_save { self.email = self.email.downcase }
	before_create :create_remember_token

	#Rails will take care of password stuff with this call
	has_secure_password

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end		
end

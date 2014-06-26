class User < ActiveRecord::Base
	#db associations (Rails will add methods and validations)
	has_many :microposts, dependent: :destroy #Implied foreign key "user_id" filled in by Rails
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

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

	def feed
		Micropost.from_followed_users(self)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	private

		def create_remember_token
			self.remember_token = User.digest(User.new_remember_token)
		end		
end

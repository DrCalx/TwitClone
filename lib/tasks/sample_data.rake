namespace :db do	
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_posts
		make_relations
	end
end

def make_users
	User.create!(name: "Example User",
					email: "example@user.com",
					password: "pass123",
					password_confirmation: "pass123",
					admin: true)
	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@test.com"
		password = "pass123"
		User.create!(name: name,
					email: email,
					password: password,
					password_confirmation: password)
	end
end

def make_posts
	#Create some posts
	users = User.all(limit: 6)
	50.times do
		content = Faker::Lorem.sentence(5)
		users.each { |user| user.microposts.create(content: content)}
	end
end

def make_relations
	users = User.all
	user = users.first
	followed_users = users[2..50]
	followers = users [4..35]
	followed_users.each { |followed| user.follow!(followed) }
	followers.each {|follower| follower.follow!(user) }
end
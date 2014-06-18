namespace :db do	
	desc "Fill database with sample data"
	task populate: :environment do
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
		#Create some posts
		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create(content: content)}
		end
	end
end
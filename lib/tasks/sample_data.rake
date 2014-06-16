namespace :db do	
	desc "Fill database with sample data"
	task populate: :environment do
		User.create!(name: "Example User",
						email: "example@test.com",
						password: "pass123",
						password_confirmation: "pass123")
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
end
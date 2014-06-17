FactoryGirl.define do
	factory :user do
		sequence(:name)		{|n| "Person #{n}"}
		sequence(:email)	{|n| "person-#{n}@test.com"}
		password 	"p1a2s3s4"
		password_confirmation 	"p1a2s3s4"

		factory :admin do
			admin true
		end
	end	
end
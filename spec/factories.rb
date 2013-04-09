FactoryGirl.define do
	factory :user do
		name		"Wandering Minstrel"
		email		"wmin@gmail.com"
		password	"passphrase"
		password_confirmation	"passphrase"
	end
end
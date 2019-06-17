FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    contact { "1234567891" }
    do_autosave { Faker::Boolean.boolean }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.now }
  end
end

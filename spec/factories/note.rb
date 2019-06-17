FactoryBot.define do
  factory :note do
    title { Faker::Name.name }
    description { Faker::Quote.famous_last_words }    
  end
end

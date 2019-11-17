FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.word.downcase }
  end
end

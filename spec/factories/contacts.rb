FactoryBot.define do
  factory :contact do
    user
    walter_id { Faker::Number.between(1, 1000) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { "+1#{Faker::Number.number(10)}" }
    email { Faker::Internet.email }
    occupation { Faker::Job.title }
    company { Faker::Company.name }
    hiring_authority { Faker::Boolean.boolean }
    saved { true }

    trait :saved do
      saved { true }
    end

    trait :unsaved do
      saved { false }
    end
  end
end

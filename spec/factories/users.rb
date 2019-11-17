FactoryBot.define do
  factory :user do
    origin_id { 1 }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :admin do
      abilities { [:manage_messaging] }
    end

    trait :forwarding do
      call_forwarding { true }
      call_forwarding_number { "+1#{Faker::Number.number(10)}" }
    end

    trait :with_screener do
      association :screener_number, :with_user, factory: :phone_number
    end

    trait :available do
      available { true }
    end

    trait :unavailable do
      available { false }
    end

    trait :with_caller_id_number do
      caller_id_number { "+1#{Faker::Number.number(10)}" }
    end

    factory :user_with_number do
      number factory: :phone_number
    end
  end
end

FactoryBot.define do
  factory :phone_number do
    number { "+1#{Faker::Number.number(10)}" }
    assignable { nil }
    forwarding { false }

    trait :with_user do
      association :assignable, :available, factory: :user
    end
  end
end

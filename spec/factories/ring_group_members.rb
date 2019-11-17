FactoryBot.define do
  factory :ring_group_member do
    user
    ring_group
    available { false }

    trait :available do
      available { true }
    end

    trait :unavailable do
      available { false }
    end
  end
end

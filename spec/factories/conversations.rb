FactoryBot.define do
  factory :conversation do
    user factory: :user_with_number
    contact
    read { false }

    trait :read do
      read { true }
    end

    trait :unread do
      read { false }
    end
  end
end

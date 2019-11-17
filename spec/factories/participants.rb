FactoryBot.define do
  factory :participant do
    call factory: :incoming_call
    contact
    sid { Faker::Number.number(10) }

    trait :initiated do
      status { :initiated }
    end

    trait :in_progress do
      status { :in_progress }
    end

    trait :completed do
      status { :completed }
    end
  end
end

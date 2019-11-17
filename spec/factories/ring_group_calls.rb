FactoryBot.define do
  factory :ring_group_call do
    ring_group
    from_phone_number { "+1#{Faker::Number.number(10)}" }
    from_sid { Faker::Number.number(10) }
    to { ["+1#{Faker::Number.number(10)}"] }
  end
end

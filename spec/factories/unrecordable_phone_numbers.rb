FactoryBot.define do
  factory :unrecordable_phone_number do
    number { "+1#{Faker::Number.number(10)}" }
  end
end

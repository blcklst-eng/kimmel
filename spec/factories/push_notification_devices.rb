FactoryBot.define do
  factory :push_notification_device do
    user
    token { Faker::Number.number(20) }
  end
end

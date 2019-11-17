FactoryBot.define do
  factory :ring_group do
    name { Faker::Job.title }

    factory :ring_group_with_number do
      number factory: :phone_number
    end
  end
end

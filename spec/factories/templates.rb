FactoryBot.define do
  factory :template do
    user
    body { Faker::Lorem.sentence(4) }
    tags { ["test"] }

    factory :global_template do
      user { nil }
    end
  end
end

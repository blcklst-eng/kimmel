FactoryBot.define do
  factory :voicemail do
    voicemailable factory: :incoming_call
    audio { ActiveStorageHelpers.create_blob }
    viewed { false }
    sid { Faker::Number.number(10) }
    archived { false }

    trait :viewed do
      viewed { true }
    end

    trait :not_viewed do
      viewed { false }
    end

    trait :archived do
      archived { true }
    end

    trait :expired do
      created_at { Time.current - Voicemail::EXPIRES - 1.day }
    end
  end
end

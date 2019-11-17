FactoryBot.define do
  factory :recording do
    call factory: :incoming_call
    audio { ActiveStorageHelpers.create_blob }
    sid { Faker::Number.number(10) }
    duration { 20 }
  end
end

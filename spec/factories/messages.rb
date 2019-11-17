FactoryBot.define do
  factory :message do
    conversation
    body { Faker::Lorem.sentence(3) }
  end

  factory :outgoing_message, parent: :message, class: OutgoingMessage
  factory :incoming_message, parent: :message, class: IncomingMessage
end

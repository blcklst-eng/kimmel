FactoryBot.define do
  factory :transfer_request do
    participant
    receiver factory: :user
    response { nil }
    contact
  end
end

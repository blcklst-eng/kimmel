FactoryBot.define do
  factory :call_transition do
    call factory: :incoming_call
    to_state { "in_progress" }
    sort_key { 10 }
    most_recent { true }
  end
end

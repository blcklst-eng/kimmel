FactoryBot.define do
  factory :call do
    user
    sid { Faker::Number.number(10) }
    viewed { [true, false].sample }
    quality_issue { false }

    trait :initiated do
      transitions { build_list(:call_transition, 1, call: @instance, to_state: :initiated) }
    end

    trait :in_progress do
      transitions { build_list(:call_transition, 1, call: @instance, to_state: :in_progress) }
    end

    trait :completed do
      transitions { build_list(:call_transition, 1, call: @instance, to_state: :completed) }
    end

    trait :no_answer do
      transitions { build_list(:call_transition, 1, call: @instance, to_state: :no_answer) }
    end

    trait :recorded do
      recorded { true }
    end

    trait :internal do
      internal { true }
    end

    trait :not_viewed do
      viewed { false }
    end

    after(:create) do |call|
      call.transitions.each(&:save!)
    end
  end

  factory :outgoing_call, parent: :call, class: OutgoingCall
  factory :incoming_call, parent: :call, class: IncomingCall

  trait :with_participant do
    transient do
      contact { nil }
    end

    after(:create) do |call, evaluator|
      if evaluator.contact
        create(:participant, call: call, contact: evaluator.contact)
      else
        create(:participant, call: call)
      end
    end
  end
end

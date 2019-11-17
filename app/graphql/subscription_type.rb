class SubscriptionType < Types::BaseObject
  extend GraphQL::Subscriptions::SubscriptionRoot

  field :message_received,
    Outputs::MessageType,
    null: false,
    subscription_scope: :current_user_id do
      argument :conversation_id, ID, required: false
    end
  field :message_sent,
    Outputs::MessageType,
    null: false,
    subscription_scope: :current_user_id do
      argument :conversation_id, ID, required: false
    end
  field :message_status_changed,
    Outputs::MessageType,
    null: false,
    subscription_scope: :current_user_id do
      argument :message_id, ID, required: true
    end
  field :ongoing_call,
    Outputs::CallType,
    null: false,
    description: "The state of an ongoing call was changed" do
      argument :user_id, ID, required: false
    end
  field :participant_status_changed,
    Outputs::ParticipantType,
    null: false,
    description: "The status of a participant changed" do
      argument :participant_id, ID, required: true
    end
  field :user_availability, Outputs::UserType, null: false
  field :ring_group_member_availability,
    Outputs::RingGroupMemberType,
    null: false,
    description: "The availability of a member for the specified ring group changed" do
      argument :ring_group_id, ID, required: false
    end
  field :counts,
    Outputs::CountsType,
    null: false,
    subscription_scope: :current_user_id
  field :transfer_request,
    Outputs::TransferRequestType,
    null: false,
    subscription_scope: :current_user_id
end

module Outputs
  class UserType < Types::BaseObject
    implements Types::ActiveRecord

    field :walter_id, ID, null: true
    field :email, String, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :phone_number, String, null: false
    field :caller_id_number, String, null: true
    field :admin, Boolean, null: false
    field :available, Boolean, null: false
    field :availability_note, String, null: true
    field :call_forwarding, Boolean, null: false
    field :call_forwarding_number, String, null: true
    field :voicemail_greeting_url,
      String,
      description: "The location of the recorded greeting message for this user",
      null: true
    field :ring_group_memberships, [RingGroupMemberType], null: false
    field :calls, CallType.connection_type, null: true
    field :ongoing_calls, [CallType], null: false
    field :see_calling,
      Boolean,
      null: false,
      description: <<~DESC
        A feature flag that indicates whether the user should be
        able to see calling related features.
      DESC
    field :email_voicemails, Boolean, null: false

    def phone_number
      Loaders::AssociationLoader.for(User, :number).load(@object).then { @object.phone_number }
    end

    def admin
      @object.admin?
    end

    def see_calling
      @object.see_calling?
    end

    def voicemail_greeting_url
      Loaders::AssociationLoader.for(User, :voicemail_greeting_blob).load(@object).then do |blob|
        RouteHelper.rails_blob_url(blob) if blob
      end
    end

    def ring_group_memberships
      Loaders::AssociationLoader.for(User, :ring_group_memberships).load(@object)
    end

    def ongoing_calls
      Loaders::AssociationLoader.for(User, :in_progress_calls).load(@object)
    end

    def calls
      Loaders::AssociationLoader.for(User, :calls).load(@object)
    end
  end
end

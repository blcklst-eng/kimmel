module Outputs
  class RingGroupType < Types::BaseObject
    implements Types::ActiveRecord

    field :name, String, null: false
    field :ring_group_members, RingGroupMemberType.connection_type, null: false
    field :ring_group_calls, RingGroupCallType.connection_type, null: false
    field :voicemails, VoicemailType.connection_type, null: false
    field :voicemail_greeting_url,
      String,
      description: "The location of the recorded greeting message for this ring group",
      null: true
    field :phone_number, String, null: false

    def ring_group_members
      Loaders::AssociationLoader.for(RingGroup, :members).load(@object)
    end

    def ring_group_calls
      Loaders::AssociationLoader.for(RingGroup, :ring_group_calls).load(@object)
    end

    def voicemails
      Loaders::AssociationLoader.for(RingGroup, :voicemails).load(@object)
    end

    def voicemail_greeting_url
      Loaders::AssociationLoader
        .for(RingGroup, :voicemail_greeting_blob)
        .load(@object)
        .then do |blob|
          RouteHelper.rails_blob_url(blob) if blob
        end
    end

    def phone_number
      Loaders::AssociationLoader.for(RingGroup, :number).load(@object).then(&:number)
    end
  end
end

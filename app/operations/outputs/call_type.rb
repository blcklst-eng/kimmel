module Outputs
  module CallType
    include Types::BaseInterface
    include Types::ActiveRecord

    field :user, UserType, null: false
    field :sid, String, null: true
    field :original_participant, ParticipantType, null: false
    field :participants, [ParticipantType], null: false
    field :status, Types::CallStatusType, null: false
    field :missed, Boolean, null: false
    field :duration, Integer, null: false
    field :answered_at, GraphQL::Types::ISO8601DateTime, null: true
    field :recordable, Boolean, null: false
    field :recorded, Boolean, null: false
    field :recording, RecordingType, null: true
    field :viewed, Boolean, null: false
    field :quality_issue, Boolean, null: false
    field :internal,
      Boolean,
      description: "Indicates whether the call is between users",
      null: false

    def user
      Loaders::AssociationLoader.for(Call, :user).load(@object)
    end

    def original_participant
      Loaders::AssociationLoader.for(Call, :participants).load(@object).then do
        @object.original_participant
      end
    end

    def participants
      Loaders::AssociationLoader.for(Call, :participants).load(@object)
    end

    def status
      Loaders::AssociationLoader.for(Call, :transitions).load(@object).then do
        @object.current_state
      end
    end

    def missed
      Loaders::AssociationLoader.for(Call, :transitions).load(@object).then do
        @object.missed?
      end
    end

    def answered_at
      Loaders::AssociationLoader.for(Call, :transitions).load(@object).then do
        @object.answered_at
      end
    end

    def recording
      Loaders::AssociationLoader.for(Call, :recording).load(@object)
    end

    def recordable
      Loaders::AssociationLoader.for(Call, :participants).load(@object).then do
        @object.recordable?
      end
    end

    orphan_types IncomingCallType, OutgoingCallType

    definition_methods do
      def resolve_type(object, _context)
        if object.is_a?(OutgoingCall)
          OutgoingCallType
        elsif object.is_a?(IncomingCall)
          IncomingCallType
        else
          raise "Unexpected CallType: #{object.inspect}"
        end
      end
    end
  end
end

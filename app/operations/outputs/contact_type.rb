module Outputs
  class ContactType < Types::BaseObject
    implements Types::ActiveRecord

    field :walter_id, Integer, null: true
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :full_name, String, null: true
    field :phone_number, String, null: false
    field :identity,
      String,
      null: false,
      description: <<~DESC
        The way the contact is identified to the user. If the contact
        has a name then identity is the name. If the contact doesn't
        have a name then identity is the phone number.
      DESC
    field :email, String, null: true
    field :company, String, null: true
    field :occupation, String, null: true
    field :hiring_authority, Boolean, null: false
    field :notes, String, null: true
    field :conversation, ConversationType, null: true
    field :calls, CallType.connection_type, null: false
    field :recordings, RecordingType.connection_type, null: false
    field :voicemails, VoicemailType.connection_type, null: false
    field :saved, Boolean, null: false
    field :last_contact_at,
      GraphQL::Types::ISO8601DateTime,
      null: true,
      description: <<~DESC
        Date and time of the last communication that has been received
        from this contact via incoming calls and incoming messages
      DESC

    def conversation
      Loaders::AssociationLoader.for(Contact, :conversation).load(@object)
    end

    def calls
      Loaders::AssociationLoader.for(Contact, :calls).load(@object)
    end

    def recordings
      Loaders::AssociationLoader.for(Contact, :recordings).load(@object)
    end

    def voicemails
      Loaders::AssociationLoader.for(Contact, :voicemails).load(@object)
    end
  end
end

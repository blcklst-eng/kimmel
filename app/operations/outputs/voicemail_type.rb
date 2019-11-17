module Outputs
  class VoicemailType < Types::BaseObject
    implements Types::ActiveRecord

    field :call, VoicemailableType, null: false
    field :url, String, null: false
    field :viewed, Boolean, null: false
    field :archived, Boolean, null: false
    field :expiration, GraphQL::Types::ISO8601DateTime, null: true
    field :hidden, Boolean, null: false, description: "For @client directive usage on frontend"
    field :transcription,
      String,
      null: true,
      deprecation_reason: "Voicemail transcriptions have been removed."

    def call
      Loaders::AssociationLoader.for(Voicemail, :voicemailable).load(@object)
    end

    def url
      Loaders::AssociationLoader.for(Voicemail, :audio_blob).load(@object).then do |blob|
        RouteHelper.rails_blob_url(blob)
      end
    end

    def transcription
      nil
    end

    def hidden
      false
    end
  end
end

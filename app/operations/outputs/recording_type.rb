module Outputs
  class RecordingType < Types::BaseObject
    implements Types::ActiveRecord

    field :call, CallType, null: false
    field :sid, String, null: false
    field :url, String, null: false
    field :duration, Integer, null: false
    field :hidden, Boolean, null: false, description: "For @client directive usage on frontend"

    def call
      Loaders::AssociationLoader.for(Recording, :call).load(@object)
    end

    def url
      Loaders::AssociationLoader.for(Recording, :audio_blob).load(@object).then do |blob|
        RouteHelper.rails_blob_url(blob)
      end
    end

    def self.authorized?(object, context)
      Loaders::AssociationLoader.for(Recording, :user).load(object).then do
        RecordingPolicy.new(context[:current_user], object).view?
      end
    end

    def hidden
      false
    end
  end
end

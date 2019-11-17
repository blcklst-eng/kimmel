module Outputs
  module MessageMediaType
    include Types::BaseInterface
    include Types::ActiveRecord

    field :url, String, null: false
    field :location, String, null: false, deprecation_reason: "Renamed to url"
    field :content_type, String, null: false
    field :type, String, null: false, deprecation_reason: "Renamed to contentType"
    field :filename, String, null: false
    field :extension, String, null: false

    def content_type
      @object.blob.content_type
    end

    alias type content_type

    def url
      RouteHelper.rails_blob_url(@object)
    end

    alias location url

    def filename
      @object.filename.to_s
    end

    def extension
      @object.filename.extension
    end

    orphan_types MessageMediaFileType, MessageMediaImageType

    definition_methods do
      def resolve_type(object, _context)
        if object.image?
          MessageMediaImageType
        else
          MessageMediaFileType
        end
      end
    end
  end
end

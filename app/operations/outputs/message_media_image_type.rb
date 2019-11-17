module Outputs
  class MessageMediaImageType < Types::BaseObject
    implements MessageMediaType

    field :height, String, null: false
    field :width, String, null: false
    field :thumbnail, MessageMediaImageVariantType, null: false
    field :medium, MessageMediaImageVariantType, null: false
    field :large, MessageMediaImageVariantType, null: false

    def height
      @object.metadata[:height]
    end

    def width
      @object.metadata[:width]
    end

    def thumbnail
      MessageMediaImageVariant.new(media: @object, width: 128, height: 128)
    end

    def medium
      MessageMediaImageVariant.new(media: @object, width: 512, height: 512)
    end

    def large
      MessageMediaImageVariant.new(media: @object, width: 1024, height: 1024)
    end
  end
end

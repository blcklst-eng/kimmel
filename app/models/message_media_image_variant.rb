class MessageMediaImageVariant
  def initialize(media:, height:, width:)
    @height = height
    @width = width
    @original = media
    @variant = original.variant(resize: "#{height} x #{width}")
  end

  def height
    return original_height unless apply?

    original_height * ratio
  end

  def width
    return original_width unless apply?

    original_width * ratio
  end

  def url
    RouteHelper.rails_representation_url(variant)
  end

  private

  attr_reader :original, :variant

  def original_height
    original.metadata[:height]
  end

  def original_width
    original.metadata[:width]
  end

  def apply?
    @height < original_height && @width < original_width
  end

  def ratio
    if @height > @width
      @height.to_f / original_height.to_f
    else
      @width.to_f / original_width.to_f
    end
  end
end

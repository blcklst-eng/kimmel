class Template < ApplicationRecord
  has_many :tagged, as: :taggable, dependent: :delete_all
  has_many :tags, -> { order(:id) }, through: :tagged, source: :tag

  belongs_to :user, optional: true

  validates :body, presence: true
  validates :tags, presence: true

  scope :for_user, ->(user) { where(user: user) }
  scope :global, -> { where(user: nil) }
  scope :search_by_tag, ->(tag) { joins(:tags).where("tags.name LIKE ?", "#{tag.downcase}%") }

  def tags=(new_tags)
    tags.delete_all
    new_tags.each do |tag|
      add_tag(tag)
    end
  end

  def global?
    user.nil?
  end

  private

  def add_tag(tag)
    tag = Tag.find_or_create_by(name: tag)
    tags << tag
  end
end

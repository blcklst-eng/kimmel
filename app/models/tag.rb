class Tag < ApplicationRecord
  has_many :tagged, dependent: :delete_all
  has_many :items, through: :tagged

  validates :name, presence: true

  def name=(value)
    if value.nil?
      super(value)
    else
      super(value.downcase)
    end
  end

  def to_s
    name
  end
end

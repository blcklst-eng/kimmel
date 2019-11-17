class Tagged < ApplicationRecord
  self.table_name = "tagged"

  belongs_to :taggable, polymorphic: true
  belongs_to :tag
end

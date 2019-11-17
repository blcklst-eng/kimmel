class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  acts_as_paranoid

  scope :latest, -> { order(created_at: :desc) }
end

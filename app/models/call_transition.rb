class CallTransition < ApplicationRecord
  belongs_to :call, inverse_of: :transitions

  scope :in_progress, -> { where(to_state: :in_progress) }
end

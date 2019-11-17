class AvailabilityPolicy < ApplicationPolicy
  def manage?
    user.admin? || user == record
  end
end

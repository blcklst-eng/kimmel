class RingGroupPolicy < ApplicationPolicy
  def view?
    user.admin? || record.member?(user)
  end

  def manage?
    user.admin?
  end
end

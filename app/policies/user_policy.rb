class UserPolicy < ApplicationPolicy
  def manage?
    user.admin?
  end
end

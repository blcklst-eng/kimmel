class GlobalTemplatePolicy < ApplicationPolicy
  def manage?
    user.admin?
  end
end

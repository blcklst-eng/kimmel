class TemplatePolicy < ApplicationPolicy
  def view?
    return true if record.global?

    user_is_admin_or_owns_the_record?
  end

  def manage?
    user_is_admin_or_owns_the_record?
  end
end

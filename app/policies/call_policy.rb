class CallPolicy < ApplicationPolicy
  def manage?
    user_is_admin_or_owns_the_record?
  end

  alias view? manage?
end

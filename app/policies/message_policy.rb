class MessagePolicy < ApplicationPolicy
  def retry?
    user.number? && user_is_admin_or_owns_the_record?
  end
end

class ConversationPolicy < ApplicationPolicy
  def view?
    user.number? && user_is_admin_or_owns_the_record?
  end
end

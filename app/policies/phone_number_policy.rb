class PhoneNumberPolicy < ApplicationPolicy
  def manage?
    user.admin?
  end
end

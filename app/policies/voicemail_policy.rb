class VoicemailPolicy < ApplicationPolicy
  def view?
    user.admin? || record.owner?(user)
  end

  alias manage? view?
end

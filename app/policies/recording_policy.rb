class RecordingPolicy < ApplicationPolicy
  def view?
    return true if user.admin?

    record.recorded? && user == record.user
  end
end

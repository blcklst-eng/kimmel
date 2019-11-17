class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def logged_in?
    !user.guest?
  end

  private

  def user_is_admin_or_owns_the_record?
    user.admin? || user == record.user
  end
end

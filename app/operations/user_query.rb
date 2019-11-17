class UserQuery < Types::BaseResolver
  description "Gets the specified user"
  argument :id, ID, required: true
  type Outputs::UserType, null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    User.find(input.id)
  end
end

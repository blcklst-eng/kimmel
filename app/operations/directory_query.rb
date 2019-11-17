class DirectoryQuery < Types::BaseResolver
  description "Gets all the users with a number for a directory list"
  type Outputs::UserType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    User.with_number.order_by_name
  end
end

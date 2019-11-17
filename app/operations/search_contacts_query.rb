class SearchContactsQuery < Types::BaseResolver
  description "Searches contacts using the provided query"
  argument :query, String, required: true
  type [Outputs::ContactType], null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    ContactSearch.new(query: input.query, user: current_user).results
  end
end

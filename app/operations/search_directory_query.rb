class SearchDirectoryQuery < Types::BaseResolver
  description "Searches the directory for users with numbers using the provided query"
  argument :query, String, required: true
  type [Outputs::UserType], null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    DirectorySearch.new(query: input.query).results
  end
end

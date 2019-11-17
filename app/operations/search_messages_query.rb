class SearchMessagesQuery < Types::BaseResolver
  description "Searches messages using the provided query"
  argument :query, String, required: true
  type [Outputs::MessageType], null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    MessageSearch.new(query: input.query, user: current_user).results
  end
end

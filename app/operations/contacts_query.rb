class ContactsQuery < Types::BaseResolver
  description "Gets all contacts for the current user"
  argument :sort_by,
    Inputs::ContactSortByType,
    "The column to sort the results by",
    default_value: :name,
    required: false
  argument :sort_order,
    Types::SortOrderType,
    "The direction to sort the results",
    default_value: :asc,
    required: false
  type Outputs::ContactType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Contact
      .saved
      .for_user(current_user)
      .order_by(sort_by, sort_order)
  end

  private

  def sort_by
    input.sort_by
  end

  def sort_order
    input.sort_order
  end
end

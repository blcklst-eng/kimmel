class ViewedCallsMutation < Types::BaseMutation
  description "Marks all calls as viewed"

  argument :contact_id, ID, required: false

  field :success, Boolean, null: true

  policy ApplicationPolicy, :logged_in?

  def resolve
    calls = if input.contact_id
      Call.for_contact(contact)
    else
      Call
    end

    if calls.for_user(current_user).mark_viewed
      {success: true}
    else
      {success: false}
    end
  end

  private

  def contact
    Contact.find_by!(id: input.contact_id, user: current_user)
  end
end

class ContactSearch
  attr_reader :query, :user

  def initialize(query:, user:)
    @query = query
    @user = user
  end

  def results
    @results ||= Contact.search(
      query,
      fields: fields,
      where: where,
      misspellings: misspellings,
      limit: 5
    )
  end

  private

  def where
    {user_id: user.id, saved: true}
  end

  def fields
    [
      {full_name: :text_middle},
      {phone_number: :word_middle},
    ]
  end

  def misspellings
    {fields: [:full_name], edit_distance: 2}
  end
end

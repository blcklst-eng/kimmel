class DirectorySearch
  attr_reader :query, :user

  def initialize(query:)
    @query = query
  end

  def results
    @results ||= User.search(
      query,
      fields: fields,
      where: where,
      misspellings: misspellings,
      limit: 5
    )
  end

  private

  def where
    {
      phone_number: {not: nil},
    }
  end

  def fields
    [
      {full_name: :text_middle},
      {id: :word},
    ]
  end

  def misspellings
    {fields: [:full_name], edit_distance: 2}
  end
end

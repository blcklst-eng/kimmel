class MessageSearch
  attr_reader :query, :user

  def initialize(query:, user:)
    @query = query
    @user = user
  end

  def results
    @results ||= Message.search query, where: where, fields: fields, limit: 5
  end

  private

  def where
    {user_id: user.id}
  end

  def fields
    [:body]
  end
end

module GraphQLHelpers
  def execute(query, as: Guest.new, context: {}, variables: {})
    context[:current_user] = as unless context.key?(:current_user)
    MessagingSchema.execute(
      query,
      context: context,
      variables: variables.with_indifferent_access
    ).with_indifferent_access
  end
end

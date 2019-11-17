class MessagingSchema < GraphQL::Schema
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST
  use GraphQL::Subscriptions::ActionCableSubscriptions
  use GraphQL::Tracing::SkylightTracing, set_endpoint_name: true
  use GraphQL::Batch

  mutation(MutationType)
  query(QueryType)
  subscription(SubscriptionType)
end

# Workaround to prevent a duplicate types error on app boot
# This is from a thread unsafe race condition bug in graphql-ruby
# See open issue here https://github.com/rmosolgo/graphql-ruby/issues/1505
MessagingSchema.graphql_definition

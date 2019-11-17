require "graphql/rake_task"

GraphQL::RakeTask.new(
  dependencies: [:environment],
  schema_name: "MessagingSchema",
  directory: "app/graphql"
)

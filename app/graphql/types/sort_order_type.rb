module Types
  class SortOrderType < Types::BaseEnum
    graphql_name "SortOrderType"
    description "The direction to sort results"
    value "ASC", value: :asc
    value "DESC", value: :desc
  end
end

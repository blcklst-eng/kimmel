module Inputs
  class Template < Types::BaseInputObject
    graphql_name "TemplateInput"
    description "A message template"

    argument :tags, [String], required: true
    argument :body, String, required: true
  end
end

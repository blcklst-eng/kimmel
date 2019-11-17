class TemplateQuery < Types::BaseResolver
  description "Gets the specified template"
  argument :id, ID, required: true
  type Outputs::TemplateType, null: true
  policy TemplatePolicy, :view?

  def resolve
    Template.find(input.id).tap { |template| authorize template }
  end
end

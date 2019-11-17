class UpdateTemplateMutation < Types::BaseMutation
  description "Updates the specified template"

  argument :id, ID, required: true
  argument :template_input, Inputs::Template, required: true

  field :template, Outputs::TemplateType, null: true
  field :errors, resolver: Resolvers::Error

  policy TemplatePolicy, :manage?

  def resolve
    template = Template.find(input.id)
    authorize template

    if template.update(template_input)
      {template: template, errors: []}
    else
      {template: nil, errors: template.errors}
    end
  end

  private

  def template_input
    input.template_input.to_h
  end
end

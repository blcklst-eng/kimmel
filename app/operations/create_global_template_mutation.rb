class CreateGlobalTemplateMutation < Types::BaseMutation
  description "Creates a new global message template"

  argument :template_input, Inputs::Template, required: true

  field :template, Outputs::TemplateType, null: true
  field :errors, resolver: Resolvers::Error

  policy GlobalTemplatePolicy, :manage?

  def authorized_resolve
    template = Template.new(template_input)

    if template.save
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

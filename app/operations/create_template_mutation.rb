class CreateTemplateMutation < Types::BaseMutation
  description "Creates a new message template"

  argument :template_input, Inputs::Template, required: true

  field :template, Outputs::TemplateType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

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
    input.template_input.to_h.merge(user: current_user)
  end
end

class DeleteTemplateMutation < Types::BaseMutation
  description "Deletes the specified template"

  argument :id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy TemplatePolicy, :manage?

  def resolve
    template = Template.find(input.id)
    authorize template
    template.destroy

    {success: template.deleted?, errors: template.errors}
  end
end

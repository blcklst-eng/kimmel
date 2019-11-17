class GlobalTemplatesQuery < Types::BaseResolver
  description "Gets all the global templates"
  type Outputs::TemplateType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Template.global
  end
end

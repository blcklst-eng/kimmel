class TemplatesQuery < Types::BaseResolver
  description "Gets all the templates for a current user"
  type Outputs::TemplateType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Template.for_user(current_user)
  end
end

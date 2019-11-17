class TemplatesSearchQuery < Types::BaseResolver
  description "Searches for a template based on a tag"
  argument :tag, String, required: true
  type [Outputs::TemplateType], null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Template.for_user(current_user).or(Template.global).search_by_tag(input.tag)
  end
end

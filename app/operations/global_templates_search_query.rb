class GlobalTemplatesSearchQuery < Types::BaseResolver
  description "Searches for a global template based on a tag"
  argument :tag, String, required: true
  type [Outputs::TemplateType], null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Template.global.search_by_tag(input.tag)
  end
end

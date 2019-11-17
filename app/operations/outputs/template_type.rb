module Outputs
  class TemplateType < Types::BaseObject
    implements Types::ActiveRecord

    field :tags, [String], null: false
    field :body, String, null: false
    field :global, Boolean, null: false

    def tags
      Loaders::AssociationLoader.for(Template, :tags).load(@object)
    end

    def global
      @object.global?
    end
  end
end

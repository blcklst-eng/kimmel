module Outputs
  class PhoneNumberObjectType < Types::BaseObject
    implements Types::ActiveRecord

    field :user, Outputs::UserType, null: true
    field :phone_number, String, null: false
    field :forwarding, Boolean, null: false

    def user
      Loaders::AssociationLoader.for(PhoneNumber, :user).load(@object)
    end
  end
end

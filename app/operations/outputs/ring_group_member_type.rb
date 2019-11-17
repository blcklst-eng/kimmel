module Outputs
  class RingGroupMemberType < Types::BaseObject
    implements Types::ActiveRecord

    field :user, UserType, null: false
    field :ring_group, RingGroupType, null: false
    field :available, Boolean, null: false

    def user
      Loaders::AssociationLoader.for(RingGroupMember, :user).load(@object)
    end

    def ring_group
      Loaders::AssociationLoader.for(RingGroupMember, :ring_group).load(@object)
    end
  end
end

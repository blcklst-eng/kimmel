module Inputs
  class PatchAvailability < Types::BaseInputObject
    graphql_name "PatchAvailabilityInput"
    description "Properties for an patching the availability of a user"
    argument :available, Boolean, required: false
    argument :availability_note, String, required: false
  end
end

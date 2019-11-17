module Inputs
  class PatchContact < Types::BaseInputObject
    graphql_name "PatchContactInput"
    description "Properties for an patching a Contact"
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :phone_number, Types::PhoneNumberType, required: false
    argument :email, String, required: false
    argument :company, String, required: false
    argument :occupation, String, required: false
    argument :hiring_authority, Boolean, required: false
    argument :notes, String, required: false
  end
end

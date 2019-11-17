module Inputs
  class Contact < Types::BaseInputObject
    graphql_name "ContactInput"
    description "Properties for an Contact"
    argument :first_name, String, required: false
    argument :last_name, String, required: false
    argument :phone_number, Types::PhoneNumberType, required: true
    argument :email, String, required: false
    argument :company, String, required: false
    argument :occupation, String, required: false
    argument :hiring_authority, Boolean, required: false
    argument :notes, String, required: false
  end
end

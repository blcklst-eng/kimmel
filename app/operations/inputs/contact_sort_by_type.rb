module Inputs
  class ContactSortByType < Types::BaseEnum
    graphql_name "ContactSortByType"
    description "Possible columns to sort contacts by"
    value "NAME", value: :name
    value "COMPANY", value: :company
    value "LAST_CONTACT", value: :last_contact_at
  end
end

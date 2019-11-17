module Types
  class CallStatusType < Types::BaseEnum
    description "Valid statuses for a call"

    Call.statuses.each do |status|
      value status.upcase, value: status
    end
  end
end

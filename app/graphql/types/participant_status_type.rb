module Types
  class ParticipantStatusType < Types::BaseEnum
    description "Valid statuses for a participant"

    Participant.statuses.keys.each do |status|
      value status.upcase, value: status
    end
  end
end

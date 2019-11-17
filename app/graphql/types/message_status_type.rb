module Types
  class MessageStatusType < Types::BaseEnum
    description "The delivery statuses a message can have"

    value "SENT",
      "The message has been sent but we have not yet gotten a delivery confirmation",
      value: "sent"
    value "DELIVERED",
      "The message has been successfully delivered.",
      value: "delivered"
    value "FAILED",
      "The message has failed to deliver. Sending of this message can be retried.",
      value: "failed"
  end
end

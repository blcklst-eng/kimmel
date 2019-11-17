module Types
  class PhoneNumberType < Types::BaseScalar
    description "A string representation of the phone number"

    def self.coerce_input(value, _ctx)
      TwilioAdapter.new.lookup(value)
    end

    def self.coerce_result(value, _ctx)
      value.to_s
    end
  end
end

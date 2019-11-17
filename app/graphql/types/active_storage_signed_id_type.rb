module Types
  class ActiveStorageSignedIdType < Types::BaseScalar
    description "A valid signed id to be used with file uploads"

    class << self
      def coerce_input(value, _ctx)
        raise GraphQL::CoercionError, "#{value} is not a valid signed id" unless valid?(value)

        value
      end

      private

      def valid?(value)
        ActiveStorage.verifier.valid_message?(value)
      end
    end
  end
end

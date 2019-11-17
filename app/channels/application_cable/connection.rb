module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      user = authenticate_user
      reject_unauthorized_connection if user.guest?
      user
    end

    def authenticate_user
      TokenAuthentication.new(params["token"]).authenticate
    end

    def params
      request.query_parameters
    end
  end
end

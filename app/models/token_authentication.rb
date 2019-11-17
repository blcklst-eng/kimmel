class TokenAuthentication
  attr_reader :token_string

  def initialize(token_string)
    @token_string = token_string
  end

  def authenticate
    decoded_token = Token.decode(token_string)

    if decoded_token.valid?
      decoded_token.user.tap { |user| user.abilities = decoded_token.abilities }
    else
      Guest.new
    end
  end
end

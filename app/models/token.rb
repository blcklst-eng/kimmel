class Token
  ALGORITHM = "HS256".freeze
  SECRET = Rails.application.credentials[Rails.env.to_sym][:jwt_secret]

  def self.decode(token)
    new(JWT.decode(token, SECRET, algorithm: ALGORITHM).first.symbolize_keys)
  rescue JWT::DecodeError
    new
  end

  attr_reader :email, :abilities

  def initialize(email: nil, abilities: [], **)
    @email = email
    @abilities = abilities
  end

  def user
    @user ||= User.find_by(email: email)
  end

  def valid?
    user.present?
  end
end

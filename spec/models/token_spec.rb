require "rails_helper"

RSpec.describe Token do
  describe ".decode" do
    it "it decodes the provided token body" do
      user = create(:user)
      token_body = token_string(user)

      decoded_token = described_class.decode(token_body)

      expect(decoded_token).to be_a(described_class)
      expect(decoded_token.user).to eq(user)
      expect(decoded_token).to be_valid
    end

    it "it contains the users abilities" do
      user = create(:user)
      token_body = token_string(user, ["manage_messaging"])

      decoded_token = described_class.decode(token_body)

      expect(decoded_token.abilities).to include("manage_messaging")
    end

    it "it decodes the provided invalid token body" do
      decoded_token = described_class.decode("invalid-token-body")

      expect(decoded_token).to be_a(described_class)
      expect(decoded_token).not_to be_valid
      expect(decoded_token.user).to be_nil
    end
  end

  describe "#user" do
    it "finds a user" do
      user = create(:user)
      token = described_class.new(email: user.email)

      result = token.user

      expect(result).to eq(user)
    end
  end

  describe "#valid?" do
    it "is valid with a user" do
      user = create(:user)
      token = described_class.new(email: user.email)

      expect(token).to be_valid
    end

    it "is invalid without a user" do
      token = described_class.new(email: "invalid@email.com")

      expect(token).not_to be_valid
    end
  end

  def token_string(user, abilities = [])
    JWT.encode({email: user.email, abilities: abilities}, Token::SECRET, Token::ALGORITHM)
  end
end

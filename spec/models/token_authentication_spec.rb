require "rails_helper"

RSpec.describe TokenAuthentication do
  it "returns the authenticated user with a valid token" do
    user = create(:user)
    token_body = token_string(user)
    auth = described_class.new(token_body)

    authenticated_user = auth.authenticate

    expect(authenticated_user).to eq(user)
  end

  it "sets the abilities on the returned user" do
    user = create(:user)
    token_body = token_string(user, ["manage_messaging"])
    auth = described_class.new(token_body)

    user = auth.authenticate

    expect(user.abilities).to include(:manage_messaging)
  end

  it "returns a guest when provided with an invalid token" do
    auth = described_class.new("not-valid-token")

    guest_user = auth.authenticate

    expect(guest_user).to be_a(Guest)
  end

  def token_string(user, abilities = [])
    JWT.encode({email: user.email, abilities: abilities}, Token::SECRET, Token::ALGORITHM)
  end
end

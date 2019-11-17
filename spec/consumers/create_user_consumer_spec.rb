require "rails_helper"

RSpec.describe CreateUserConsumer do
  it "creates a User based on the data in the message" do
    message = double("message", value: payload)

    result = subject.process(message)

    expect(result).to be(true)
    user = User.first
    expect(user.email).to eq("john@kimmel.com")
  end

  it "updates a user if the user already exists" do
    user = create(:user, origin_id: 123, email: "john@kimmel.com", first_name: "Jonathan")
    message = double("message", value: payload)
    result = subject.process(message)

    expect(result).to be(true)
    expect(user.reload.first_name).to eq("John")
  end

  it "ignores the message if the type is not correct" do
    message = double("message", value: ActiveSupport::JSON.encode(type: "user_updated"))
    result = subject.process(message)

    expect(result).to be(false)
  end

  def payload
    ActiveSupport::JSON.encode(
      type: "user_created",
      user: user_data
    )
  end

  def user_data
    {
      id: 123,
      intranet_id: 123,
      walter_id: 123,
      email: "john@kimmel.com",
      preferred_name: "John",
      last_name: "Doe",
    }
  end
end

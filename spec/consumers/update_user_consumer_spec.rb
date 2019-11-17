require "rails_helper"

RSpec.describe UpdateUserConsumer do
  it "updates a user" do
    user = create(:user, origin_id: 123, email: "john@kimmel.com", first_name: "Jonathan")
    message = double("message", value: payload)

    result = subject.process(message)

    expect(result).to be(true)
    expect(user.reload.first_name).to eq("John")
  end

  it "ignores the message if the type is not correct" do
    message = double("message", value: ActiveSupport::JSON.encode(type: "user_created"))
    result = subject.process(message)

    expect(result).to be(false)
  end

  def payload
    ActiveSupport::JSON.encode(
      type: "user_updated",
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

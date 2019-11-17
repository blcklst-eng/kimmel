require "factory_bot_rails"
require "faker"
require_relative "../spec/support/active_storage_helpers"

user_data = [
  {
    origin_id: 1,
    first_name: "John",
    last_name: "Doe",
    email: "test@kimmel.com",
  },
  {
    origin_id: 2,
    first_name: "Jane",
    last_name: "Doe",
    email: "example@kimmel.com",
  },
  {
    origin_id: 3,
    first_name: "Jacob",
    last_name: "Haug",
    email: "jacob@kimmel.com",
  },
  {
    origin_id: 4,
    first_name: "Mark",
    last_name: "Jones",
    email: "demo@kimmel.com",
  },
  {
    origin_id: 5,
    first_name: "Charlie",
    last_name: "Kimmel",
    email: "software@kimmel.com",
  },
  {
    origin_id: 6,
    first_name: "Jeremy",
    last_name: "Kimmel",
    email: "development@kimmel.com",
  },
]

development_numbers = %w[
  +18084004547
  +18084001730
  +18084001221
  +18084006494
  +18084006476
  +18084006421
  +18084001667
  +18084000791
  +18084000910
  +18084009077
  +18084004573
]

users = user_data.map { |data|
  User.create!(
    email: data[:email],
    origin_id: data[:origin_id],
    first_name: data[:first_name],
    last_name: data[:last_name],
    number: PhoneNumber.create!(number: development_numbers.shift)
  )
}

users.each do |user|
  users
    .select { |other_user| user.email != other_user.email }
    .each do |other_user|
      Contact.create!(
        user: user,
        first_name: other_user.first_name,
        last_name: other_user.last_name,
        phone_number: other_user.phone_number,
        email: other_user.email,
        occupation: "Consultant",
        company: "Kimmel",
        hiring_authority: false,
        saved: true
      )
    end
end

users.each do |user|
  Template.create!(
    user: user,
    body: "Do you have some time next week for a quick call to talk about the role?",
    tags: ["call"]
  )
  Template.create!(
    user: user,
    body: "I’d love to tell you more about a couple of roles I think you’d be a great fit for.",
    tags: ["roles", "fit"]
  )
end

Template.create!(body: "Highest income opportunity for top earners", tags: ["pitch"])

FactoryBot.create(
  :ring_group,
  name: "Operators",
  number: PhoneNumber.create(number: development_numbers.shift),
  users: users
)

users.each do |user|
  # create messages
  FactoryBot.build_list(:conversation, 30, user: user, contact: nil).each do |conversation|
    conversation.update(contact: FactoryBot.build(:contact, user: user, walter_id: nil))
    20.times do
      FactoryBot.create([:incoming_message, :outgoing_message].sample, conversation: conversation)
    end
  end

  # create outgoing calls with recordings
  10.times do
    audio = ActiveStorageHelpers.create_analyzed_file_blob(filename: "sample.mp3")
    call = FactoryBot.create(
      :outgoing_call,
      :completed,
      :recorded,
      :with_participant,
      user: user,
      contact: FactoryBot.build(:contact, user: user)
    )
    FactoryBot.create(:recording, call: call, audio: audio)
  end

  # create completed incoming calls
  5.times do
    audio = ActiveStorageHelpers.create_analyzed_file_blob(filename: "sample.mp3")
    call = FactoryBot.create(
      :incoming_call,
      :completed,
      :recorded,
      :with_participant,
      user: user,
      contact: FactoryBot.build(:contact, user: user)
    )
    FactoryBot.create(:recording, call: call, audio: audio)
  end

  # create missed incoming calls with voicemails
  5.times do
    call = FactoryBot.create(
      :incoming_call,
      :no_answer,
      :with_participant,
      user: user,
      contact: FactoryBot.build(:contact, user: user)
    )
    FactoryBot.create(:voicemail,
      [:viewed, :not_viewed].sample,
      voicemailable: call,
      audio: ActiveStorageHelpers.create_analyzed_file_blob(filename: "sample.mp3"))
  end
end

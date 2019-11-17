require "rails_helper"

describe "Contact Query API", :graphql do
  describe "contact" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          contact(id: $id) {
            firstName
          }
        }
      GRAPHQL
    end

    it "gets the specified contact" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)

      result = execute query, as: user, variables: {id: contact.id}

      first_name = result[:data][:contact][:firstName]
      expect(first_name).to eq(contact.first_name)
    end
  end

  describe "contact conversation" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          contact(id: $id) {
            conversation {
              id
            }
          }
        }
      GRAPHQL
    end

    it "gets the conversation for the specified contact" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      conversation = create(:conversation, contact: contact, user: user)

      result = execute query, as: user, variables: {id: contact.id}

      conversation_id = result[:data][:contact][:conversation][:id]
      expect(conversation_id).to eq(conversation.id.to_s)
    end
  end

  describe "contact calls" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          contact(id: $id) {
            calls {
              edges {
                node {
                  id
                }
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the calls for the specified contact" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      call = create(:incoming_call, :with_participant, user: user, contact: contact)

      result = execute query, as: user, variables: {id: contact.id}

      nodes = result[:data][:contact][:calls][:edges].pluck(:node)
      expect(nodes).to include(id: call.id.to_s)
    end
  end

  describe "contact recordings" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          contact(id: $id) {
            recordings {
              edges {
                node {
                  id
                }
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the recordings for the specified contact" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      call = create(:incoming_call, :with_participant, user: user, contact: contact, recorded: true)
      recording = create(:recording, call: call)

      result = execute query, as: user, variables: {id: contact.id}

      nodes = result[:data][:contact][:recordings][:edges].pluck(:node)
      expect(nodes).to include(id: recording.id.to_s)
    end
  end

  describe "contact voicemails" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          contact(id: $id) {
            voicemails {
              edges {
                node {
                  id
                }
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the voicemails for the specified contact" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      call = create(:incoming_call, :with_participant, user: user, contact: contact)
      voicemail = create(:voicemail, voicemailable: call)

      result = execute query, as: user, variables: {id: contact.id}

      nodes = result[:data][:contact][:voicemails][:edges].pluck(:node)
      expect(nodes).to include(id: voicemail.id.to_s)
    end
  end
end

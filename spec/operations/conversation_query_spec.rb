require "rails_helper"

describe "Conversation Query API", :graphql, :active_storage do
  describe "conversation" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            id
          }
        }
      GRAPHQL
    end

    it "gets the specified conversation" do
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)

      result = execute query, as: user, variables: {id: conversation.id}

      id = result[:data][:conversation][:id]
      expect(id).to eq(conversation.id.to_s)
    end
  end

  describe "conversation user" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            user {
              id
              phoneNumber
            }
          }
        }
      GRAPHQL
    end

    it "gets the user for the specified conversation" do
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)

      result = execute query, as: user, variables: {id: conversation.id}

      user_id = result[:data][:conversation][:user][:id]
      expect(user_id).to eq(user.id.to_s)
    end
  end

  describe "conversation contact" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            contact {
              id
            }
          }
        }
      GRAPHQL
    end

    it "gets the contact for the specified conversation" do
      user = create(:user_with_number)
      contact = create(:contact, user: user)
      conversation = create(:conversation, user: user, contact: contact)

      result = execute query, as: user, variables: {id: conversation.id}

      contact_id = result[:data][:conversation][:contact][:id]
      expect(contact_id).to eq(contact.id.to_s)
    end
  end

  describe "conversation messages" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            messages {
              edges {
                node {
                  body
                }
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets a paginated list of incoming and outgoing messages in a conversation" do
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)
      incoming_message = create(:incoming_message, conversation: conversation)
      outgoing_message = create(:outgoing_message, conversation: conversation)

      result = execute query, as: user, variables: {id: conversation.id}

      message_nodes = result[:data][:conversation][:messages][:edges].pluck(:node)
      expect(message_nodes).to include(body: incoming_message.body)
      expect(message_nodes).to include(body: outgoing_message.body)
    end
  end

  describe "conversation mostRecentMessage" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            mostRecentMessage {
              body
            }
          }
        }
      GRAPHQL
    end

    it "gets the most recent message in the conversation" do
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)
      message = create(:incoming_message, conversation: conversation)

      result = execute query, as: user, variables: {id: conversation.id}

      body = result[:data][:conversation][:mostRecentMessage][:body]
      expect(body).to eq(message.body)
    end
  end

  describe "conversation media" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            id
            messages {
              edges {
                node {
                  media {
                    contentType
                    filename
                  }
                }
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the specified conversation messages with media" do
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)
      image_media = create_file_blob(filename: "ruby.jpg", content_type: "image/jpeg")
      text_media = create_blob(filename: "hello.txt")
      conversation.messages << create(:incoming_message, media: [image_media, text_media])
      conversation.messages << create(:outgoing_message)

      result = execute query, as: user, variables: {id: conversation.id}

      media_nodes = result[:data][:conversation][:messages][:edges].pluck(:node).pluck(:media)
      expect(media_nodes).to include(
        a_hash_including(contentType: "image/jpeg", filename: "ruby.jpg")
      )
      expect(media_nodes).to include(
        a_hash_including(contentType: "text/plain", filename: "hello.txt")
      )
      expect(media_nodes).to include([])
    end
  end

  describe "conversation media images" do
    let(:query) do
      <<~'GRAPHQL'
        query($id: ID!) {
          conversation(id: $id) {
            id
            messages {
              edges {
                node {
                  media {
                    ... on MessageMediaImage {
                      height
                      width
                    }
                  }
                }
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets the specified conversation messages with image media" do
      user = create(:user_with_number)
      conversation = create(:conversation, user: user)
      image_media = create_analyzed_file_blob(filename: "ruby.jpg", content_type: "image/jpeg")
      conversation.messages << create(:incoming_message, media: image_media)

      result = execute query, as: user, variables: {id: conversation.id}

      media_nodes = result[:data][:conversation][:messages][:edges].pluck(:node).pluck(:media)
      expect(media_nodes).to include(
        a_hash_including(height: "128", width: "128")
      )
    end
  end
end

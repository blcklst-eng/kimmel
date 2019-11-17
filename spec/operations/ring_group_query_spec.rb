require "rails_helper"

describe "Ring Group Query API", :graphql do
  describe "ringGroup" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroup(id: $id) {
            id
            phoneNumber
          }
        }
      GRAPHQL
    end

    it "gets the specified ring group" do
      user = create(:user)
      ring_group = create(:ring_group_with_number, users: [user])

      result = execute query, as: user, variables: {
        id: ring_group.id,
      }

      ring_group_result = result[:data][:ringGroup]
      expect(ring_group_result[:id]).to eql(ring_group.id.to_s)
    end
  end

  describe "ringGroup ringGroupCalls" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroup(id: $id) {
            id
            ringGroupCalls {
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

    it "gets the ring groups calls" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      call = create(:ring_group_call, ring_group: ring_group)

      result = execute query, as: user, variables: {
        id: ring_group.id,
      }

      nodes = result[:data][:ringGroup][:ringGroupCalls][:edges].pluck(:node)
      expect(nodes).to include(id: call.id.to_s)
    end
  end

  describe "ringGroup ringGroupMembers" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroup(id: $id) {
            id
            ringGroupMembers {
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

    it "gets the ring groups calls" do
      user = create(:user)
      ring_group = create(:ring_group)
      membership = create(:ring_group_member, ring_group: ring_group, user: user)

      result = execute query, as: user, variables: {
        id: ring_group.id,
      }

      nodes = result[:data][:ringGroup][:ringGroupMembers][:edges].pluck(:node)
      expect(nodes).to include(id: membership.id.to_s)
    end
  end

  describe "ringGroup voicemails" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          ringGroup(id: $id) {
            id
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

    it "gets the ring groups voicemails" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      call = create(:ring_group_call, ring_group: ring_group)
      voicemail = create(:voicemail, voicemailable: call)

      result = execute query, as: user, variables: {
        id: ring_group.id,
      }

      nodes = result[:data][:ringGroup][:voicemails][:edges].pluck(:node)
      expect(nodes).to include(id: voicemail.id.to_s)
    end
  end
end

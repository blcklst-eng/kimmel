require "rails_helper"

describe "User Query API", :graphql do
  describe "user" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            id
          }
        }
      GRAPHQL
    end

    it "returns a user" do
      user = create(:user)
      returned_user = create(:user)

      result = execute query, as: user, variables: {
        id: returned_user.id,
      }

      user = result[:data][:user]
      expect(user[:id]).to eq(returned_user.id.to_s)
    end
  end

  describe "user ringGroupMemberships" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            id
            ringGroupMemberships {
              id
            }
          }
        }
      GRAPHQL
    end

    it "returns the ring group membership for the user" do
      user = create(:user)
      membership = create(:ring_group_member, user: user)

      result = execute query, as: user, variables: {
        id: user.id,
      }

      ring_group_result = result[:data][:user][:ringGroupMemberships]
      expect(ring_group_result).to include(id: membership.id.to_s)
    end
  end

  describe "user ongoingCalls" do
    let(:query) do
      <<-'GRAPHQL'
        query($id: ID!) {
          user(id: $id) {
            id
            ongoingCalls {
              id
            }
          }
        }
      GRAPHQL
    end

    it "returns the active calls for the user" do
      user = create(:user)
      active_call = create(:incoming_call, :in_progress, user: user)
      completed_call = create(:incoming_call, :completed, user: user)

      result = execute query, as: user, variables: {
        id: user.id,
      }

      calls = result[:data][:user][:ongoingCalls]
      expect(calls).to include(id: active_call.id.to_s)
      expect(calls).not_to include(id: completed_call.id.to_s)
    end
  end

  describe "user calls" do
    let(:query) do
      <<~GRAPHQL
        query($id: ID!) {
          user(id: $id) {
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

    it "returns calls for a user" do
      user = create(:user)
      call = create(:incoming_call, user: user)

      result = execute query, as: build(:user), variables: {
        id: user.id,
      }

      expect(result[:data][:user][:calls][:edges].pluck(:node)).to include(id: call.id.to_s)
    end
  end
end

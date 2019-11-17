class ParkParticipant
  def initialize(participant:, user:)
    @participant = participant
    @user = user
  end

  def call
    call = create_call

    if connect_call_to_conference(call).success?
      call.transition_to(:initiated)
      Result.success
    else
      Result.failure("Failed to update call")
    end
  end

  private

  attr_reader :participant, :user, :adapter

  def connect_call_to_conference(call)
    ConnectCallToConference.new(call: call, sids: [participant.sid]).call
  end

  def create_call
    IncomingCall.create(user: user).tap do |call|
      call.add_participant(phone_number: participant.phone_number, sid: participant.sid)
    end
  end
end

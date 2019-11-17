class SendParticipantToVoicemail
  def initialize(participant:, user:)
    @participant = participant
    @user = user
  end

  def call
    voicemail_call = create_call
    ConnectCallToVoicemail.new(incoming_call: voicemail_call).call
  end

  private

  attr_reader :participant, :user

  def create_call
    IncomingCall.create(user: user).tap do |call|
      call.transition_to(:no_answer)
      call.add_participant(phone_number: participant.phone_number, sid: participant.sid)
    end
  end
end
